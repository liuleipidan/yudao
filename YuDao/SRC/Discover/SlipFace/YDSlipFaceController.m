//
//  YDSlipFaceController.m
//  YuDao
//
//  Created by 汪杰 on 2017/1/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSlipFaceController.h"
#import "YDSlipFaceModel.h"
#import "YDCustomCardView.h"
#import "CCDraggableContainer.h"
#import "YDUserFilesController.h"
#import "YDPopViewManager.h"

//每页用户数量
static NSInteger const kSlipFacePageCount = 25;

@interface YDSlipFaceController ()<CCDraggableContainerDataSource, CCDraggableContainerDelegate>

//数据索引，初始从0开始
@property (nonatomic, assign) NSUInteger startIndex;

//用户数据
@property (nonatomic, strong) NSArray<YDSlipFaceModel *> *data;

//是否还有更多数据
@property (nonatomic, assign) BOOL hasMore;

//卡片容器
@property (nonatomic, strong) CCDraggableContainer *container;

//左滑按钮
@property (nonatomic, strong) UIButton *leftButton;

//右滑按钮
@property (nonatomic, strong) UIButton *rightButton;

//背景视图
@property (nonatomic, strong) UIImageView *backgroundImageV;

//上一个被滑走的用户
@property (nonatomic, strong) YDSlipFaceModel *lastUser;

//当前正在显示的用户
@property (nonatomic, strong) YDSlipFaceModel *currentShowUser;

@end

@implementation YDSlipFaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init UI
    [self.navigationItem setTitle:@"刷脸"];
    
    [self.view yd_addSubviews:@[self.backgroundImageV,self.container,self.leftButton,self.rightButton]];
    
    //request data
    self.hasMore = YES;
    [self downloadSlipFaceData];
    
}

- (void)dealloc{
    YDLog(@"dealloc class = %@",NSStringFromClass(self.class));
    [YDPopViewManager attemptDealloc];
}

#pragma mark - Events
- (void)sf_rightBarButtonItemAction:(UIBarButtonItem *)item{
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == -1) {
            [UIAlertController YD_alertController:self title:@"确认举报此用户？" subTitle:nil items:@[@"确认"] style:UIAlertControllerStyleAlert clickBlock:^(NSInteger index) {
                if (index == 1) {
                    NSDictionary *paramer = @{
                                              @"d_id":YDNoNilNumber(self.currentShowUser.ub_id),
                                              @"type":@2
                                              };
                    [YDNetworking GET:kDynamicReportURL parameters:paramer success:^(NSNumber *code, NSString *status, id data) {
                        [YDMBPTool showText:@"举报成功"];
                    } failure:^(NSError *error) {
                        [YDMBPTool showText:@"举报失败"];
                    }];
                }
            }];
        }
    }];
}

//MARK:下载刷脸数据
- (void)downloadSlipFaceData{
    
    [YDLoadingHUD showLoadingInView:self.view];
    
    NSString *lon = [NSString stringWithFormat:@"%f",[YDUserLocation sharedLocation].userCoor.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",[YDUserLocation sharedLocation].userCoor.latitude];
    
    NSDictionary *parameters = @{
                                 @"access_token":YDAccess_token,
                                 @"ud_location":[NSString stringWithFormat:@"%@,%@",lon,lat],
                                 @"start":@(self.startIndex)
                                 };
    NSLog(@"parameters = %@",parameters);
    YDWeakSelf(self);
    [YDNetworking GET:kSlipFaceUrl parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            
            weakself.data = [YDSlipFaceModel mj_objectArrayWithKeyValuesArray:data];
            
            if (weakself.startIndex == 0 && weakself.data.count == 0) {
                [UIAlertController YD_OK_AlertController:self title:@"很抱歉，没\"刷\"到任何人" message:@"未匹配到与您相应的用户\n或今日可\"刷\"到的人数已达上限" clickBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                return ;
            }
            //只够第一次加载
            else if (weakself.startIndex == 0 && weakself.data.count != 0 && weakself.data.count < kSlipFacePageCount){
                weakself.hasMore = NO;
            }
            else if (weakself.startIndex != 0 && weakself.data.count == 0){
                [UIAlertController YD_OK_AlertController:weakself title:@"今天的已\"刷\"完" clickBlock:^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                }];
            }
            
            //载入数据
            if (weakself.data.count > 0) {
                weakself.currentShowUser = weakself.data.firstObject;
                [weakself.backgroundImageV sd_setImageWithURL:[NSURL URLWithString:weakself.currentShowUser.ud_face] placeholderImage:[UIImage imageNamed:kDefaultAvatarPath]];
                [weakself.container reloadData];
                
                if (weakself.navigationItem.rightBarButtonItem == nil) {
                    //右侧举报
                    [weakself.navigationItem setRightBarButtonItem:[UIBarButtonItem itemWithImage:@"navigation_item_more" target:self action:@selector(sf_rightBarButtonItemAction:)]];
                }
            }
            else{
                weakself.navigationItem.rightBarButtonItem = nil;
            }
        }
        else if(status.length > 0){
            [UIAlertController YD_OK_AlertController:weakself title:status clickBlock:^{
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSError *error) {
        if (error.code == -1001) {
            [UIAlertController YD_OK_AlertController:self title:@"请求超时" clickBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [YDMBPTool showInfoImageWithMessage:@"请求失败" hideBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}
//喜欢这个人
- (void)likeUserActionByIndex:(NSInteger )index{
    if (index >= self.data.count) {
        return;
    }
    
    YDSlipFaceModel *model = [self.data objectAtIndex:index];
    NSDictionary *parameters = @{@"access_token":YDAccess_token,
                                 @"ub_id":model.ub_id,
                                 @"type":@2
                                 };
    if ([model.enjoymy isEqual:@1]) {
        [self performSelector:@selector(showLikeEachOtherWithUser:) withObject:model afterDelay:0.35];
    }
    
    [YDNetworking POST:kAddLikeUserURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"slip face like: code = %@",code);
    } failure:^(NSError *error) {
        YDLog(@"slip face like: error = %@",error);
    }];
    
}

//不喜欢
- (void)dislikeUserActionByIndex:(NSInteger)index{
    if (index >= self.data.count) {
        return;
    }
    YDSlipFaceModel *model = [self.data objectAtIndex:index];
    NSDictionary *parameters = @{@"access_token":YDAccess_token,
                                 @"fuid":model.ub_id};
    [YDNetworking GET:kDislikeUserURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"slip face dislike: code = %@",code);
    } failure:^(NSError *error) {
        YDLog(@"slip face dislike: error = %@",error);
    }];
}

//相互喜欢
- (void)showLikeEachOtherWithUser:(YDSlipFaceModel *)model{
    YDWeakSelf(self);
    [[YDPopViewManager shareIntance] showPopViewWithUserName:model.ub_nickname leftImageUrl:model.ud_face rightImageUrl:[YDUserDefault defaultUser].user.ud_face selectedBlock:^(NSInteger index) {
        if (index == 1) {
            
            YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:model.ub_id?model.ub_id:@0];
            viewM.userName = model.ub_nickname;
            viewM.userHeaderUrl = model.ud_face;
            YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
            [weakself.navigationController pushViewController:userVC animated:YES];
        }
    }];
}

#pragma mark - Events
- (void)slipFaceLeftButtonAction:(UIButton *)leftBtn{
    [self.container removeFormDirection:CCDraggableDirectionLeft];
}

- (void)slipFaceRightButtonAction:(UIButton *)rightBtn{
    
    [self.container removeFormDirection:CCDraggableDirectionRight];
}

#pragma mark - CCDraggableContainer DataSource
- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    YDCustomCardView *cardView = [[YDCustomCardView alloc] initWithFrame:draggableContainer.bounds];
    [cardView setModel:self.data[index]];
    return cardView;
}

- (NSInteger)numberOfIndexs {
    return self.data? self.data.count : 0;
}

#pragma mark - CCDraggableContainerDelegate
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
    if (draggableDirection == CCDraggableDirectionLeft) {
        self.leftButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (draggableDirection == CCDraggableDirectionRight) {
        self.rightButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

//点击图片
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex {
    YDSlipFaceModel *model = [self.data objectAtIndex:didSelectIndex];
    
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:model.ub_id];
    viewM.userName = model.ub_nickname;
    viewM.userHeaderUrl = model.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    [self.navigationController pushViewController:userVC animated:YES];
}
//图片被滑完时调用
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    
    if (finishedDraggableLastCard && !self.hasMore) {
        self.navigationItem.rightBarButtonItem = nil;
        [UIAlertController YD_OK_AlertController:self title:@"今天的已\"刷\"完" clickBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else if (finishedDraggableLastCard && self.hasMore && self.startIndex == 0) {
        
        self.hasMore = NO;
        self.startIndex = 25;
        [self downloadSlipFaceData];
    }
    
}
//滑动结束
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
finishedDraggableCardIndex:(NSInteger )index{
    
    //切换背景图片
    NSInteger backgroundImageIndx = 0;
    if (index+1 == self.data.count) {
        backgroundImageIndx = index;
    }
    else{
        backgroundImageIndx = index+1;
    }
    _currentShowUser = [self.data objectAtIndex:backgroundImageIndx];
    [self.backgroundImageV sd_setImageWithURL:[NSURL URLWithString:_currentShowUser.ud_face] placeholderImage:[UIImage imageNamed:kDefaultAvatarPath]];
    
    //右滑喜欢
    if (draggableContainer.direction == CCDraggableDirectionRight) {
        [self likeUserActionByIndex:index];
    }
    //左滑不喜欢
    else if (draggableContainer.direction == CCDraggableDirectionLeft){
        [self dislikeUserActionByIndex:index];
    }
    
}

#pragma mark - Getters
- (UIImageView *)backgroundImageV{
    if (_backgroundImageV == nil) {
        _backgroundImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _backgroundImageV.contentMode = UIViewContentModeScaleAspectFit;
        
        //高斯模糊
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        effectView.frame = _backgroundImageV.bounds;
        
        [_backgroundImageV addSubview:effectView];
    }
    return _backgroundImageV;
}

- (CCDraggableContainer *)container{
    if (_container == nil) {
        _container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(0, 10, CCWidth, CCWidth*1.26) style:CCDraggableStyleUpOverlay];
        _container.delegate = self;
        _container.dataSource = self;
    }
    return _container;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [YDUIKit buttonWithImage:[UIImage imageNamed:@"discover_slipFace_hate"]  target:self];
        CGSize size = [UIImage imageNamed:@"discover_slipFace_hate"].size;
        _leftButton.frame = CGRectMake(CGRectGetMinX(self.container.frame)+45, CGRectGetMaxY(self.container.frame)+kHeight(25), size.width, size.height);
        [_leftButton addTarget:self action:@selector(slipFaceLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [YDUIKit buttonWithImage:[UIImage imageNamed:@"discover_slipFace_like"]  target:self];
        CGSize size = [UIImage imageNamed:@"discover_slipFace_like"].size;
        _rightButton.frame = CGRectMake(CGRectGetMaxX(self.container.frame)-size.width-45, CGRectGetMaxY(self.container.frame)+kHeight(25), size.width, size.height);
        [_rightButton addTarget:self action:@selector(slipFaceRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end

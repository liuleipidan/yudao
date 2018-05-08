//
//  YDDynamicDetailsController.m
//  YuDao
//
//  Created by 汪杰 on 16/12/20.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDynamicDetailsController.h"
#import "YDDynamicDetailsController+Delgate.h"

@interface YDDynamicDetailsController ()

@property (nonatomic, strong) YDDynamicDetailsHeaderView *headerView;

@end

@implementation YDDynamicDetailsController

- (instancetype)initWithViewModel:(YDDynamicDetailViewModel *)viewModel{
    if(self = [super init]){
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dc_initUI];
    
    //[self.headerView updateWithHeaderUrl:_viewModel.dy_userIcon name:_viewModel.dy_userName gender:nil level:nil time:_viewModel.dy_time looktimes:@0];
    [self.navigationItem setTitle:_viewModel.dy_label];
    
    [YDLoadingHUD showLoadingInView:self.view];
    
    [self requestDynamicDetails];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //关闭键盘的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关闭键盘的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    [_viewModel cancelCurrentTask];
}

//请求动态详情
- (void)requestDynamicDetails{
    YDWeakSelf(self);
    [_viewModel requestDynamicFinish:^(YDRequestDyDetailFinishType type) {
        
        if (weakself.tableView.mj_header) {
            [weakself.tableView.mj_header endRefreshing];
        }
        
        if (type == YDRequestDyDetailFinishTypeSuccess) {
            weakself.dyModel = weakself.viewModel.dyDetailModel;
            [weakself updateSubviewsData];
            [weakself scrollToSelectedImage];
            [weakself scrollToCommentOrLike];
        }else if (type == YDRequestDyDetailFinishTypeNonexistent){
            [YDMBPTool showInfoImageWithMessage:@"动态已被删除" hideBlock:^{
                [weakself.navigationController popViewControllerAnimated:YES];
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(momentHadDeleted:)]) {
                    [weakself.delegate momentHadDeleted:weakself.viewModel.moment];
                }
                else if (weakself.needRefreshBlock) {
                    weakself.needRefreshBlock();
                }
            }];
        }else{
            [YDMBPTool showInfoImageWithMessage:@"请求失败" hideBlock:nil];
        }
    }];
}
//滑动到评论或喜欢
- (void)scrollToCommentOrLike{
    if (_viewModel.scrollToComment) {
        _viewModel.scrollToComment = NO;
        _comtentTo = nil;
        [self.tableView scrollToBottomWithAnimation:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.commentView show];
        });
        
    }
    else if (_viewModel.scrollToLike){
        _viewModel.scrollToLike = NO;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
//滑动到选择的视图位置
- (void)scrollToSelectedImage{
    //滑动到点击图片的位置
    if (self.dyModel.d_image.count == 0 || _viewModel.imageIndex == 0) return;
    YDDDImagesCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSInteger tag = 1000 + _viewModel.imageIndex;
    UIImageView *imageV = [cell.imageViews viewWithTag:tag];
    CGRect frame = [cell.contentView convertRect:imageV.frame toView:self.tableView];
    CGFloat offsetY = frame.origin.y - 20;
    CGFloat contentH = self.tableView.contentSize.height;
    if ((contentH - offsetY) < (SCREEN_HEIGHT-64)) {
        [self.tableView scrollToBottomWithAnimation:YES];
    }else{
        [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    _viewModel.imageIndex = 0;
}

#pragma mark - Private Methods
//初始化UI
- (void)dc_initUI{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigation_item_more" target:self action:@selector(dynamicDetailRightBarItemAction:)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(IS_IPHONEX ? 66.f: 46.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self registeCellClass];
}
//导航栏右侧按钮事件
- (void)dynamicDetailRightBarItemAction:(UIBarButtonItem *)item{
    __block NSString *title = nil;
    if ([self.dyModel.ub_id isEqual:[YDUserDefault defaultUser].user.ub_id]) {
        title = @"删除";
    }else{
        title = @"举报";
    }
    YDWeakSelf(self);
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:title otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == -1) {
            [UIAlertController YD_alertController:self title:[NSString stringWithFormat:@"确认%@此动态？",title] subTitle:nil items:@[@"确认"] style:UIAlertControllerStyleAlert clickBlock:^(NSInteger index) {
                if ([title isEqualToString:@"删除"] && index == 1) {
                    NSDictionary *paramer = @{@"d_id":_viewModel.dy_id,
                                              @"access_token":YDAccess_token};
                    
                    [YDNetworking postUrl:kDeleteDynamicURL parameters:paramer success:^(NSURLSessionDataTask *task, id responseObject) {
                        NSDictionary *data = [responseObject mj_JSONObject];
                        NSLog(@"code = %@, status = %@",[data valueForKey:@"status_code"],[data valueForKey:@"status"]);
                        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(momentHadDeleted:)]) {
                            [weakself.delegate momentHadDeleted:weakself.viewModel.moment];
                        }
                        else if (weakself.needRefreshBlock) {
                            weakself.needRefreshBlock();
                        }
                        [weakself.navigationController popViewControllerAnimated:YES];
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        YDLog(@"删除动态失败,error = %@",error);
                    }];
                }
                else if ([title isEqualToString:@"举报"] && index == 1) {
                    NSDictionary *paramer = @{@"d_id":_viewModel.dy_id};
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
//刷新UI
- (void)updateSubviewsData{
    //标题
    [self.navigationItem setTitle:self.dyModel.d_label];
    
    //头部
    [self.headerView setItem:self.dyModel];
    
    //点赞
    [self.bottomView.leftBtn setTitle:self.dyModel.taplike.count == 0 ? @"点赞" : [NSString stringWithFormat:@"点赞·%ld",self.dyModel.taplike.count] forState:0];
    
    for (YDTapLikeModel *model in self.dyModel.taplike) {
        if ([model.ub_id isEqual:[YDUserDefault defaultUser].user.ub_id]) {
            self.bottomView.leftBtn.selected = YES;
            break;
        }
    }
    //评论
    [self.bottomView.centerBtn setTitle:[NSString stringWithFormat:@"评论·%ld",self.dyModel.commentdynamic.count] forState:0];
    
    [self.tableView reloadData];
}

#pragma mark - Getters
- (YDTableView *)tableView{
    if (!_tableView) {
        _tableView = [[YDTableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableHeaderView:self.headerView];
        
        YDWeakSelf(self);
        MJRefreshGifHeader *header = [YDRefreshTool yd_MJheaderRefreshingBlock:^{
            [weakself requestDynamicDetails];
        }];
        _tableView.mj_header = header;
    }
    return _tableView;
}

- (YDDynamicDetailsHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[YDDynamicDetailsHeaderView alloc] initWithFrame:CGRectMake(0,5,SCREEN_WIDTH,60)];
        YDWeakSelf(self);
        [_headerView setDHClickedAvatarBlock:^(YDDynamicDetailModel *item) {
            YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:item.ub_id];
            viewM.userName = item.ub_nickname;
            viewM.userHeaderUrl = item.ud_face;
            YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
            [weakself.navigationController pushViewController:userVC animated:YES];
        }];
    }
    return _headerView;
}

- (YDDynamicDetailsBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[YDDynamicDetailsBottomView alloc] initWithFrame:CGRectZero];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (YDDynamicCommentView *)commentView{
    if (!_commentView) {
        _commentView = [[YDDynamicCommentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _commentView.delegate = self;
    }
    return _commentView;
}

@end

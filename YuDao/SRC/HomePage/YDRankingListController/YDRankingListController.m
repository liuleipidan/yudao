//
//  YDRankingListController.m
//  YuDao
//
//  Created by 汪杰 on 16/12/13.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDRankingListController.h"
#import "YDRankingListController+Delegate.h"
#import "YDDBHPRankListStore.h"
#import "YDIgnoreView.h"
#import "YDSettingHelper.h"
#import "YDSingleRankingViewModel.h"
#import "YDRankListViewController.h"

@interface YDRankingListController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIButton *allBtn;

@end

@implementation YDRankingListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rl_initUI];
    
    [self rl_registerCells];
    
    self.data = [NSMutableArray arrayWithArray:[YDDBHPRankListStore selectAllRankListData]];
    
    [self downloadRankingListData];
    
    [[YDUserDefault defaultUser] addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rightBtn.hidden = !YDHadLogin;
}

- (void)dealloc{
    [[YDUserDefault defaultUser] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - YDUserDefaultDelegate
- (void)defaultUserAlreadyLogged:(YDUser *)user{
    [self downloadRankingListData];
}
- (void)defaultUserExitingLogin{
    [self downloadRankingListData];
}

#pragma mark - Events
//点击筛选排行榜按钮
- (void)rankinglistRightButtonAction:(UIButton *)button{
    CGRect initFrame =  [self.view convertRect:button.frame toView:[UIApplication sharedApplication].keyWindow];
    [YDIgnoreView showAtFrame:initFrame type:YDIgnoreViewTypeTwoRow clickedBlock:^(NSUInteger index) {
        //更新数据库
        YDHPIgnoreModel *ignore = [YDHPIgnoreModel createIgnoreModelByModuleType:YDHomePageModuleTypeRankList subType:0];
        ignore.ignore_type = @(index);
        [YDSettingHelper addHPIgnoreByIgnoreModel:ignore success:nil failure:nil];
        
        [[YDHomePageManager manager] removeIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    }];
    
}
//点击查看全部
- (void)rl_allButtonAction:(UIButton *)sender{
    [self.parentViewController.navigationController pushViewController:[YDRankListViewController new] animated:YES];
}

#pragma mark - Public Methods
- (void)downloadRankingListData{
    NSInteger grade = [YDUserDefault defaultUser].user.ub_auth_grade.integerValue;
    //根据用户是否登录和用户登录请求不同的排行榜数据
    if (YDHadLogin) {
        if (grade >= 5) {//时速
            self.dataType = YDRankingListDataTypeSpeed;
        }
        else if (grade >= 2 && grade < 5){//积分
            self.dataType = YDRankingListDataTypeScore;
        }
        else{//喜欢
            self.dataType = YDRankingListDataTypeLike;
        }
    }
    else{
        self.dataType = YDRankingListDataTypeLike;
    }
    
    YDWeakSelf(self);
    NSDictionary *param = @{
                            @"access_token":YDAccess_token,
                            @"rankingtype":[YDSingleRankingViewModel rankingListDataTypeString:self.dataType]
                            };
    [YDNetworking GET:kAllRankinglistURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        NSArray *lists = [YDListModel mj_objectArrayWithKeyValuesArray:data];
        if (lists.count > 0) {
            NSArray *tempArr = [lists subarrayWithRange:NSMakeRange(0, lists.count >=10 ? 10 : lists.count)];
            weakself.data = [NSMutableArray arrayWithArray:tempArr];
            //存储到数据库
            [YDDBHPRankListStore insertRankListData:weakself.data];
        }
        else{
            weakself.data = [NSMutableArray arrayWithArray:@[]];
            //存储到数据库
            [YDDBHPRankListStore insertRankListData:weakself.data];
        }
        [weakself.collectionView reloadData];
        
        //数据加载完成代理
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(rankingListControllerDataDidLoad:)]) {
            [weakself.delegate rankingListControllerDataDidLoad:weakself];
        }
        
    } failure:^(NSError *error) {
        YDLog(@"下载排行榜数据失败 error = %@",error);
        //数据加载完成代理
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(rankingListControllerDataDidLoad:)]) {
            [weakself.delegate rankingListControllerDataDidLoad:weakself];
        }
    }];
}
- (void)rl_initUI{
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = [UIColor searchBarBackgroundColor];
    [self.view yd_addSubviews:@[self.titleLabel,self.rightBtn,self.collectionView,self.allBtn,separatorView]];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(9);
        make.left.equalTo(_titleLabel);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(175);
    }];
    
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(separatorView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(36);
    }];
    
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(10);
    }];
    
}

#pragma mark - Getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:18]];
        _titleLabel.text = @"排行榜";
        _titleLabel.frame = CGRectMake(10, 10, 150, 21);
    }
    return _titleLabel;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"homePage_message_more_gray"] forState:0];
        [_rightBtn addTarget:self action:@selector(rankinglistRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(120, 175);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 8;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 244, self.view.frame.size.width,130) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollsToTop = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIButton *)allBtn{
    if (_allBtn == nil) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBtn setBackgroundColor:[UIColor grayBackgoundColor]];
        [_allBtn setTitle:@"查看全部" forState:0];
        [_allBtn setTitleColor:[UIColor grayTextColor] forState:0];
        _allBtn.titleLabel.font = [UIFont font_14];
        [_allBtn addTarget:self action:@selector(rl_allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBtn;
}

@end

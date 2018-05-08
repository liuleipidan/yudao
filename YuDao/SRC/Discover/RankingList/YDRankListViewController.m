//
//  YDRankListViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/1/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDRankListViewController.h"
#import "YDRankListViewController+Delegate.h"

@interface YDRankListViewController()<YDContainerControllerDelegate>


@end

@implementation YDRankListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"排行榜"];
    
    [self.view addSubview:self.containerVC.view];
    
    [self.containerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem itemWithImage:@"dis_rank_more" target:self action:@selector(discover_rankingList_rightBarItemAction:)]];
    
    _currentRankListIndex = 0;
    _currentRankingVC = self.oneVC;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController yd_hiddenBottomImageView:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController yd_hiddenBottomImageView:NO];
}

- (void)setInitLoadController:(NSInteger )index{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.containerVC setSelectedIndex:index animated:NO];
    });
    
}

#pragma mark - Event Actions
//点击右边筛选按钮
- (void)discover_rankingList_rightBarItemAction:(UIBarButtonItem *)item{
    if (self.addMenuView.isShow) {
        [self.addMenuView dismiss];
    }else{
        [self.addMenuView showInView:self.navigationController.view];
    }
}

#pragma mark -- YSLContainerViewControllerDelegate
//容器控制器代理，当前控制器切换
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller{
    _currentRankListIndex = index;
    _currentRankingVC = (YDSingleRankingController *)controller;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_currentRankingVC requestRankingListWithCondition:self.condition];
    });
}

#pragma mark - Getters
- (YDAddMenuView *)addMenuView{
    if (!_addMenuView) {
        _addMenuView = [[YDAddMenuView alloc] init];
        [_addMenuView setDelegate:self];
    }
    return _addMenuView;
}

- (YDPopupController *)popControoler{
    if (_popControoler == nil) {
        _popControoler = [[YDPopupController alloc] initWithContents:@[self.filterView]];
        _popControoler.theme = [YDPopupTheme defaultTheme];
        _popControoler.theme.popupStyle = YDPopupStyleCentered;
        _popControoler.theme.cornerRadius = 8.0f;
        _popControoler.delegate = self;
    }
    return _popControoler;
}

- (YDRankListFilterView *)filterView{
    if (_filterView == nil) {
        _filterView = [[YDRankListFilterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 373)];
        YDWeakSelf(self);
        [_filterView setLFEnsureBlock:^(YDRankingListFilterCondition condition) {
            NSLog(@"condition = %ld",condition);
            [weakself.popControoler dismissPopupControllerAnimated:YES];
            //所选项和当前不一样,请求数据
            if (weakself.condition != condition) {
                if (YDHadLogin) {
                    [weakself.currentRankingVC requestRankingListWithCondition:condition];
                    weakself.condition = condition;
                }
                else{
                    if (condition == 2 || condition == 5) {
                        [YDMBPTool showInfoImageWithMessage:@"未登录" hideBlock:^{
                            [weakself presentViewController:[YDLoginViewController new] animated:YES completion:^{

                            }];
                        }];
                    }
                    else{
                        [weakself.currentRankingVC requestRankingListWithCondition:condition];
                        weakself.condition = condition;
                    }
                }

            }
        }];
    }
    return _filterView;
}

- (YDContainerController *)containerVC{
    if (!_containerVC) {
        
        YDContainerController *containerVC = [[YDContainerController alloc] initWithControllers:@[self.oneVC,self.twoVC,self.threeVC,self.fourVC,self.fiveVC,self.sixVC] topBarHeight:[[UIApplication sharedApplication] statusBarFrame].size.height + NAVBAR_HEIGHT parentController:self];
        containerVC.delegate = self;
        containerVC.scrollMenuViewHeight = 31.f;
        containerVC.menuItemFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        containerVC.menuItemTitleColor = [UIColor whiteColor];
        containerVC.menuBackgroudColor = YDBaseColor;
        containerVC.menuView.indicatorWidth = 37.0f;
        _containerVC = containerVC;
    }
    return _containerVC;
}

- (YDSingleRankingController *)oneVC{
    if (!_oneVC) {
        YDSingleRankingViewModel *viewM = [[YDSingleRankingViewModel alloc] initWithDataType:YDRankingListDataTypeMileage];
        _oneVC = [[YDSingleRankingController alloc] initWitViewModel:viewM];
        _oneVC.title = @"里程";
    }
    return _oneVC;
}

- (YDSingleRankingController *)twoVC{
    if (!_twoVC) {
        YDSingleRankingViewModel *viewM = [[YDSingleRankingViewModel alloc] initWithDataType:YDRankingListDataTypeSpeed];
        _twoVC = [[YDSingleRankingController alloc] initWitViewModel:viewM];
        _twoVC.title = @"时速";
    }
    return _twoVC;
}
- (YDSingleRankingController *)threeVC{
    if (!_threeVC) {
        YDSingleRankingViewModel *viewM = [[YDSingleRankingViewModel alloc] initWithDataType:YDRankingListDataTypeOilwear];
        _threeVC = [[YDSingleRankingController alloc] initWitViewModel:viewM];
        _threeVC.title = @"油耗";
    }
    return _threeVC;
}
- (YDSingleRankingController *)fourVC{
    if (!_fourVC) {
        YDSingleRankingViewModel *viewM = [[YDSingleRankingViewModel alloc] initWithDataType:YDRankingListDataTypeStop];
        _fourVC = [[YDSingleRankingController alloc] initWitViewModel:viewM];
        _fourVC.title = @"滞留";
    }
    return _fourVC;
}
- (YDSingleRankingController *)fiveVC{
    if (!_fiveVC) {
        YDSingleRankingViewModel *viewM = [[YDSingleRankingViewModel alloc] initWithDataType:YDRankingListDataTypeScore];
        _fiveVC = [[YDSingleRankingController alloc] initWitViewModel:viewM];
        _fiveVC.title = @"积分";
    }
    return _fiveVC;
}
- (YDSingleRankingController *)sixVC{
    if (!_sixVC) {
        YDSingleRankingViewModel *viewM = [[YDSingleRankingViewModel alloc] initWithDataType:YDRankingListDataTypeLike];
        _sixVC = [[YDSingleRankingController alloc] initWitViewModel:viewM];
        _sixVC.title = @"喜欢";
    }
    return _sixVC;
}

@end

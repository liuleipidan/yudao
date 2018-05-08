//
//  YDHomePageController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHomePageController.h"
#import "YDHomePageController+Delegate.h"
#import "YDAllDynamicController.h"
#import "YDSearchViewController.h"
#import "YDHPIgnoreStore.h"
#import "YDUserDefaultsManager.h"
#import "YDScannerViewController.h"

@interface YDHomePageController ()


@end

@implementation YDHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hpc_initUI];
    
    _phManager = [YDHomePageManager manager];
    _phManager.delegate = self;
    
#pragma mark - 预留一秒布局
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
    });
    
    //请求定位
    [YDUserLocation sharedLocation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //更新首页模块
    //[self.phManager reloadDataSourceCompletion:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //调用每日登录
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (YDHadLogin && [[YDUserDefaultsManager manager] isFirstDailyLogin]) {
            
            [YDNetworking GET:kDailyLoginURL parameters:@{@"access_token":YDAccess_token} success:nil failure:nil];
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc{
    [YDNotificationCenter removeObserver:self name:kHomePageMonitorModelNotification object:nil];
}

- (void)hpc_initUI{
    [self.navigationItem setTitle:@"遇道"];
    [self.view addSubview:self.tableView];
    [self registerCells];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-self.tabBarController.tabBar.height);
    }];
    
    //items
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem itemOffsetLeftWith:@"homePage_icon_scanner" target:self action:@selector(leftBarButtonItemAction:)]];
    
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem itemOffsetRightWith:@"homePage_icon_search" target:self action:@selector(rightBarButtonItemAction:)]];
}

#pragma mark - BarItemActions
- (void)leftBarButtonItemAction:(id)sender{
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    else{
        YDScannerViewController *scannerVC = [YDScannerViewController new];
        [scannerVC setScannerType:YDScannerTypeAll];
        [self.navigationController pushViewController:scannerVC animated:YES];
    }
}
- (void)rightBarButtonItemAction:(id)sender{
    
    [self.navigationController pushViewController:[YDSearchViewController new] animated:YES];
}

#pragma mark - Methods
/**
 添加子控制器
 */
- (void)y_addChildContentViewController:(UIViewController *)childVC{
    if (![self.childViewControllers containsObject:childVC]) {
        [self addChildViewController:childVC];
        [childVC didMoveToParentViewController:self];
        
        //排行榜
        if ([childVC isKindOfClass:[YDRankingListController class]]) {
            [(YDRankingListController *)childVC setDelegate:self];
        }
        
    }
}
/**
 移除子控制器
 */
- (void)y_removeChildContentViewController:(UIViewController *)childVC{
    if ([self.childViewControllers containsObject:childVC]) {
        [childVC willMoveToParentViewController:nil];
        [childVC removeFromParentViewController];
    }
}

#pragma mark - mj_header & mj_footer
- (void)setMJ_header{
    if (self.tableView.mj_header) {
        return;
    }
    MJRefreshHeader *header = [YDRefreshTool yd_MJheaderTarget:self action:@selector(hp_headerAction:)];
    header.ignoredScrollViewContentInsetTop = 15.f;
    self.tableView.mj_header = header;
}
- (void)hp_headerAction:(MJRefreshHeader *)header{
    [self.phManager reloadViewControllerData];
    [self.dynamicVC requestHomePageDynamics];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [header endRefreshing];
    });
}

- (void)setMj_footer{
    if (self.tableView.mj_footer) {
        return;
    }
    MJRefreshFooter *footer = [YDRefreshTool yd_MJfooterTarget:self action:@selector(hp_footerAction:)];
    //footer.ignoredScrollViewContentInsetBottom = 15.f;
    self.tableView.mj_footer = footer;
}
- (void)hp_footerAction:(MJRefreshFooter *)footer{
    
    YDAllDynamicController *allVC = [YDAllDynamicController new];
    allVC.fromFlag = 1;
    YDNavigationController *naVC = [[YDNavigationController alloc] initWithRootViewController:allVC];
    [self presentViewController:naVC animated:YES completion:nil];
    [footer endRefreshing];
}

#pragma mark - Getters
- (YDTableView *)tableView{
    if (!_tableView) {
        _tableView = [[YDTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain dataSource:self delegate:self];
        
        _tableView.backgroundColor = [UIColor searchBarBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        //推荐动态
        _tableView.tableFooterView = self.dynamicVC.view;
        [self y_addChildContentViewController:self.dynamicVC];
        
        [self setMJ_header];
        [self setMj_footer];
        
    }
    return _tableView;
}

- (YDHPDynamicController *)dynamicVC{
    if (!_dynamicVC) {
        _dynamicVC = [YDHPDynamicController new];
        _dynamicVC.delegate = self;
    }
    return _dynamicVC;
}

- (YDIndicatorTitleView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[YDIndicatorTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    }
    return _indicatorView;
}

@end

//
//  YDHomePageController.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDTrafficInfoController.h"
#import "YDTaskController.h"
#import "YDRankingListController.h"
#import "YDHomePageManager.h"
#import "YDHomePageCell.h"
#import "YDHomePageModel.h"
#import "YDHPDynamicController.h"
#import "YDHPMessageController.h"
#import "YDIndicatorTitleView.h"

@interface YDHomePageController : YDViewController
{
    YDTableView *_tableView;
    YDTrafficInfoController *_trafficInfoVC;
    YDTaskController *_taskVC;
    YDRankingListController *_rankingListVC;
    YDHPDynamicController *_dynamicVC;
}

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, strong) YDHomePageManager *phManager;

/**
 添加子控制器
 */
- (void)y_addChildContentViewController:(UIViewController *)childVC;

/**
 移除子控制器
 */
- (void)y_removeChildContentViewController:(UIViewController *)childVC;

/**
 动态
 */
@property (nonatomic, strong) YDHPDynamicController *dynamicVC;

@property (nonatomic, strong) YDIndicatorTitleView *indicatorView;

@end

//
//  YDRankListViewController.h
//  YuDao
//
//  Created by 汪杰 on 2017/1/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDAddMenuView.h"
#import "YDContainerController.h"
#import "YDSingleRankingController.h"
#import "YDPopupController.h"
#import "YDRankListFilterView.h"

//分享链接-已登陆
#define kRankListShareURL_hadLogin @"http://%@/app-share/ranking.html?access_token=%@&rankingtype=%ld"
//分享链接-未登陆
#define kRankListShareURL_notLogin @"http://%@/app-share/ranking.html?rankingtype=%ld"

@interface YDRankListViewController : YDViewController

@property (nonatomic, strong) YDContainerController *containerVC;//容器视图控制器

@property (nonatomic, strong) YDSingleRankingController *oneVC;

@property (nonatomic, strong) YDSingleRankingController *twoVC;

@property (nonatomic, strong) YDSingleRankingController *threeVC;

@property (nonatomic, strong) YDSingleRankingController *fourVC;

@property (nonatomic, strong) YDSingleRankingController *fiveVC;

@property (nonatomic, strong) YDSingleRankingController *sixVC;

@property (nonatomic, strong) YDSingleRankingController *currentRankingVC;//当前所展示的排行榜控制器

@property (nonatomic, assign) YDRankingListFilterCondition condition;//公用的筛选条件

@property (nonatomic, assign) NSInteger     currentRankListIndex;//当前排行榜

@property (nonatomic, strong) YDAddMenuView *addMenuView;

@property (nonatomic, strong) YDPopupController *popControoler;

@property (nonatomic, strong) YDRankListFilterView *filterView;

- (void)setInitLoadController:(NSInteger )index;

@end

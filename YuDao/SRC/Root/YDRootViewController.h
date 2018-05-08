//
//  YDRootViewController.h
//  YuDao
//
//  Created by 汪杰 on 16/10/26.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDTabBarController.h"

#pragma mark - 四个子控制器
#import "YDHomePageController.h"
#import "YDDiscoverController.h"
#import "YDServiceViewController.h"
#import "YDMineViewController.h"

static NSString *const kHomePageClassString = @"YDHomePageController";
static NSString *const kDiscoverClassString = @"YDDiscoverController";
static NSString *const kSerClassString = @"YDServiceViewController";
static NSString *const kMineClassString = @"YDMineViewController";


@interface YDRootViewController : YDTabBarController
{
    NSMutableArray *_messageContents;
    int _messageCount;
    int _notificationCount;
}
@property (nonatomic, strong) YDHomePageController     *homePageVC;
@property (nonatomic, strong) YDDiscoverController     *discoverVC;
@property (nonatomic, strong) YDServiceViewController   *serviceVC;
@property (nonatomic, strong) YDMineViewController       *myselfVC;

@property (nonatomic, assign) NSInteger systemMessageCount;
@property (nonatomic, assign) NSInteger friendRequestCount;
@property (nonatomic, assign) NSInteger chatMessageCount;

+ (YDRootViewController *)sharedRootViewController;

/**
 *  取得相应位置的ViewController
 *
 *  @param index 位置
 *
 *  @return 控制器
 */
- (id)childViewControllerAtIndex:(NSUInteger)index;

/**
 释放所有导航控制器的子控制器，并且指定当前显示的控制器

 @param index 根控制器的当前显示视图的索引( 0->首页, 1->发现, 2->服务, 3->我)
 */
- (void)releaseNavigationControllerAndShowViewControllerWithIndex:(NSUInteger )index;

/**
 清除ApplicationIcon和TabBarItems的角标
 */
- (void)clearApplicationIconAndTabBarItemsBadge;

#pragma mark - 收到有新消息或消息已被阅读,修改<我>控制器的角标
/**
 重新计算ApplicationIcon和TabBarItems的角标
 */
- (void)recountBadges;

@end

//
//  YDRootViewController.m
//  YuDao
//
//  Created by 汪杰 on 16/10/26.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDRootViewController.h"
#import "YDNavigationController.h"
#import "YDChatHelper+ConversationRecord.h"
#import "YDRootViewController+Delegate.h"


static YDRootViewController *rootVC = nil;

@interface YDRootViewController ()

@property (nonatomic, strong) NSArray<UINavigationController *> *childVCArray;

@property (nonatomic, weak  ) UIViewController *currentController;

@end

@implementation YDRootViewController

+ (YDRootViewController *)sharedRootViewController{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        rootVC = [[YDRootViewController alloc] init];
    });
    return rootVC;
}

- (instancetype)init{
    if (self = [super init]) {
        
        //代理为自身
        [self setDelegate:self];
        
        //添加推送消息代理
        [[YDPushMessageManager sharePushMessageManager] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //添加系统消息代理
        [[YDSystemMessageHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //添加聊天消息代理
        [[YDChatHelper sharedInstance] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //设置子控制器（首页、发现、服务和我）
    [self setViewControllers:self.childVCArray];
    
    //清除角标
    [self recountBadges];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 还是有问题啊！下次再搞吧...
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (id)childViewControllerAtIndex:(NSUInteger)index{
    return [self.childViewControllers objectAtIndex:index] ;
}

- (void)releaseNavigationControllerAndShowViewControllerWithIndex:(NSUInteger )index{
    [self.childVCArray enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj popToRootViewControllerAnimated:NO];
    }];
    [self setSelectedIndex:index];
}

#pragma mark - 清除AppIcon和《我》角标
- (void)clearApplicationIconAndTabBarItemsBadge{
    
    //App角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //tabBarItem角标
    for (UITabBarItem *item in self.tabBar.items) {
        [item setBadgeValue:nil];
    }
}

#pragma mark - 重新计算ApplicationIcon和TabBarItems的角标
- (void)recountBadges{
    if (!YDHadLogin) {
        [self clearApplicationIconAndTabBarItemsBadge];
        return;
    }
    
    //系统消息+好友请求+聊天消息+动态消息
    NSInteger allCount = self.systemMessageCount + self.friendRequestCount + self.chatMessageCount + [YDMineHelper sharedInstance].dyMsgUnreadCount;
    
    NSString *badgeValue = allCount == 0 ? nil : [NSString stringWithFormat:@"%ld",allCount];
    
    //《我》角标
    [self.myselfVC.tabBarItem setBadgeValue:badgeValue];
    
    //AppIcon角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:allCount];   //清除角标
}

#pragma mark - Getters
//未读系统消息数量
- (NSInteger )systemMessageCount{
    return [YDSystemMessageHelper sharedInstance].unreadSysCount;
}

//好友请求
- (NSInteger )friendRequestCount{
    return [YDPushMessageManager sharePushMessageManager].frCount;
}

//聊天通知
- (NSInteger )chatMessageCount{
    return [[YDChatHelper sharedInstance] allUnreadMessageByUid:[YDUserDefault defaultUser].user.ub_id];
}

- (NSArray *)childVCArray{
    if (_childVCArray == nil) {
        YDNavigationController *mainNaVC = [[YDNavigationController alloc] initWithRootViewController:self.homePageVC];
        YDNavigationController *discoverNaVC = [[YDNavigationController alloc] initWithRootViewController:self.discoverVC];
        YDNavigationController *serviceNaVC = [[YDNavigationController alloc] initWithRootViewController:self.serviceVC];
        YDNavigationController *myselfNaVC = [[YDNavigationController alloc] initWithRootViewController:self.myselfVC];
        _childVCArray = @[mainNaVC,discoverNaVC,serviceNaVC,myselfNaVC];
    }
    return _childVCArray;
}

- (YDHomePageController *)homePageVC{
    if (!_homePageVC) {
        _homePageVC = [[YDHomePageController alloc] init];
        _homePageVC.tabBarItem.title = @"首页";
        _homePageVC.tabBarItem.image = [UIImage imageNamed:@"tab_shouye_normal"];
        _homePageVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_shouye_highlight"];
    }
    return _homePageVC;
}

- (YDDiscoverController *)discoverVC{
    if (_discoverVC == nil) {
        _discoverVC = [YDDiscoverController new];
        _discoverVC.tabBarItem.title = @"发现";
        _discoverVC.tabBarItem.image = [[UIImage imageNamed:@"tab_discover_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _discoverVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_discover_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    return _discoverVC;
}

- (YDServiceViewController *)serviceVC{
    if (_serviceVC == nil) {
        //NSString *urlStr = [NSString stringWithFormat:@"http://%@/app-service/",kHtmlEnvironmentalKey];
        _serviceVC = [[YDServiceViewController alloc] init];
        _serviceVC.tabBarItem.title = @"服务";
        _serviceVC.tabBarItem.image = [UIImage imageNamed:@"tab_service_normal"];
        _serviceVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_service_highlight"];
    }
    return _serviceVC;
}

- (YDMineViewController *)myselfVC{
    if (_myselfVC == nil) {
        _myselfVC = [YDMineViewController new];
        _myselfVC.tabBarItem.title = @"我";
        _myselfVC.tabBarItem.image = [UIImage imageNamed:@"tab_mine_normal"];
        _myselfVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_mine_highlight"];
    }
    return _myselfVC;
}



@end

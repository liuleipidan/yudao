//
//  YDRootViewController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDRootViewController+Delegate.h"

@implementation YDRootViewController (Delegate)

#pragma mark - YDSystemMessageDelegate
- (void)receivedNewSystemMessages{
    
    [self recountBadges];
}

- (void)systemMessagesAreRead{
    
    [self recountBadges];
}

#pragma mark - YDPushMessageManagerDelegate
//收到好友请求
- (void)receivedNewFriendRequest{
    
    [self recountBadges];
}

//未读好友请求数量变动
- (void)unreadFirendRequestCountDidChange{
    
    [self recountBadges];
}

#pragma mark - YDChatHelperDelegate
- (void)unreadChatMessageCountHadChanged{
    
    [self recountBadges];
}

#pragma mark - UITabBarControllerDelegate
//将要切换子控制器
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    
    UIViewController *subViewController = [(UINavigationController *)viewController rootViewController];
    
    //如果用户未登录
    if (!YDHadLogin){
        //点击《服务》或《我》会弹出登录界面
        if ([subViewController isKindOfClass:self.myselfVC.class] || [subViewController isKindOfClass:self.serviceVC.class]){
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            return NO;
        }
    }
    else{
    
    }
    
    return YES;
}

//已经切换子控制器
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED{
    
}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED{
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed __TVOS_PROHIBITED{
    
}

@end

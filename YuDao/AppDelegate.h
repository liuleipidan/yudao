//
//  AppDelegate.h
//  YuDao
//
//  Created by 汪杰 on 16/9/7.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "YDNotificationManager.h"
#import "YDURLHandle.h"

#import "YDRootViewController.h"
#import "YDLaunchViewController.h"
#import "YDNavigationController.h"
#import "YDAllDynamicController.h"
#import "YDPublishDynamicController.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//主窗口
@property (strong, nonatomic) UIWindow *window;

//根控制器
@property (nonatomic, strong) YDRootViewController *rootVC;

//后台刷新回调
@property (nonatomic,copy) void (^fetchCompletionHandler) (UIBackgroundFetchResult result);

//百度地图管理类
@property (strong ,nonatomic) BMKMapManager *mapManager;

//网络状态
@property (nonatomic,assign) YDReachabilityStatus networkStatus;

@end


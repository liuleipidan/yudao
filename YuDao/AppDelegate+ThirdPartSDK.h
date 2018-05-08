//
//  AppDelegate+ThirdPartSDK.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/23.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "AppDelegate.h"

//JPush头文件
#import "JPUSHService.h"

/**
 第三方SDK初始化
 */
@interface AppDelegate (ThirdPartSDK)<JPUSHRegisterDelegate,BMKGeneralDelegate>

/**
 初始化极光推送

 @param launchOptions 启动参数
 */
- (void)yd_initJPush:(NSDictionary *)launchOptions;

/**
 初始化百度地图
 */
- (void)yd_initBaiduMap;

/**
 初始化百度统计
 */
- (void)yd_startBaiduAppCount;

/**
 初始化键盘管理
 */
- (void)yd_initIQKeyboardManager;

@end

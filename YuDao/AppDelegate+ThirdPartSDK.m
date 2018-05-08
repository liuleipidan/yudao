//
//  AppDelegate+ThirdPartSDK.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/23.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "AppDelegate+ThirdPartSDK.h"


@implementation AppDelegate (ThirdPartSDK)

//初始化极光推送
- (void)yd_initJPush:(NSDictionary *)launchOptions{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:kJPushChannel
                 apsForProduction:kJPushIsProduction
            advertisingIdentifier:nil];
    
#pragma mark - 添加极光通知监听
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //登录成功
    [defaultCenter addObserver:self selector:@selector(JPush_didLogin:)
                                        name:kJPFNetworkDidLoginNotification
                                      object:nil];
    
    //收到非APNS消息监听
    [defaultCenter addObserver:self selector:@selector(JPush_networkDidReceiveMessage:)
                                        name:kJPFNetworkDidReceiveMessageNotification
                                      object:nil];
    
}
#pragma mark - JPush登录成功回调
- (void)JPush_didLogin:(NSNotification *)noti{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
    
    //上传用户registerID（极光推送对应id）
    NSString *jPushID = [JPUSHService registrationID];
    if (jPushID) {
        [YDStandardUserDefaults setValue:jPushID forKey:kRegistrationID];
        NSDictionary *bindJPDic = @{ @"access_token":YDAccess_token,
                                     @"source":@2,
                                     @"registration_id":jPushID};
        [YDNetworking uploadJpushRegisterID:bindJPDic];
    }
}
#pragma mark - 收到静默推送(非APNS)
- (void)JPush_networkDidReceiveMessage:(NSNotification *)notification {
    /*content：获取推送的内容
     extras：获取用户自定义参数
     customizeField1：根据自定义key获取自定义的value*/
    NSDictionary * userInfo = [notification userInfo];
    [YDNotificationManager handleNoAPNSNofitication:userInfo];
}

/*****************************   处理本地消息  *************************/
//处理本地消息,当一个运行着的应用程序收到一个本地的通知 发送到委托去...
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}

//注册APNS成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    [JPUSHService registerDeviceToken:deviceToken];
}
//当 APS无法成功的完成向 程序进程推送时 发送到委托去...
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    YDLog(@"error %@", error.localizedDescription);
}

/*****************************   处理远程消息  *************************/
//当一个应用程序成功的注册一个推送服务（APS） 发送到委托去...
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // apn 内容获取：
    // 取得 APNs 标准信息内容
    [JPUSHService handleRemoteNotification:userInfo];
}
#pragma mark - iOS9以下收到推送，同时iOS10.0及以上的后台带"content-available = 1也会进入这个方法
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0 &&
        [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // 处于前台时 ，添加各种需求代码。。。。
        [YDNotificationManager handleUserClickNotification:userInfo];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0 &&
             [UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        // app 处于后台 ，添加各种需求
        [YDNotificationManager handleUserClickNotification:userInfo];
    }
    
#pragma mark - iOS10及以上在后台收到带"content-available = 1"的推送消息（主要是后台推送和静默推送）
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0 && [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        YDLog(@"iOS10及以上在后台收到带\"content-available = 1\"的推送消息!");
        
    }
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//MARK:当ios10.0 程序在前台时, 收到推送弹出的通知
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [YDNotificationManager handleUserClickNotification:userInfo];
        
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}
//MARK:程序关闭后, 通过点击推送弹出的通知
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [YDNotificationManager handleUserClickNotification:userInfo];
    }
    completionHandler();  //系统要求执行这个方法
}
#endif

#pragma mark - BaiduMapKit
//开启百度地图
- (void)yd_initBaiduMap{
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.mapManager start:kBaiduMapKey generalDelegate:self];
    if (!ret) {
        YDLog(@"开启百度地图功能失败");
    }
}

#pragma mark - BaiduMobStat
//开启百度app统计
- (void)yd_startBaiduAppCount{
    //    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    //    statTracker.enableDebugOn = NO;
    //    [statTracker startWithAppId:kBaiduMobAppKey]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

#pragma mark - IQKeyboardManager
//键盘管理
- (void)yd_initIQKeyboardManager{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    //控制整个功能是否可用
    keyboardManager.enable = YES;
    //点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    //键盘上的工具条颜色是否可用户自定义
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    //有多个输入框时，可通过toolbar操作上一个、下一个
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    //是否显示键盘上的工具条
    keyboardManager.enableAutoToolbar = YES;
    //是否显示工具条上的占位文字==textField的placeholder
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    //输入框和键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}

@end

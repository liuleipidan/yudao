//
//  AppDelegate+AppLifeCircle.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/23.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "AppDelegate+AppLifeCircle.h"

@implementation AppDelegate (AppLifeCircle)

/*应用程序将要进入非活动状态，即将进入后台
 说明：当应用程序将要进入非活动状态时执行，在此期间，应用程序不接收消息或事件，比如来电话了。*/
- (void)applicationWillResignActive:(UIApplication *)application {
    //登录openfire
    [[YDXMPPHelper sharedInstance] logoutXmpp];
    
    //iOS6.0的后台延时操作
    //    UIBackgroundTaskIdentifier backIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    //        [[UIApplication sharedApplication] endBackgroundTask:backIdentifier];
    //    }];
    
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(nonnull NSString *)identifier completionHandler:(nonnull void (^)(void))completionHandler{
    
}

/*如果应用程序支持后台运行，则应用程序已经进入后台运行
 说明：当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可。*/
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

/*应用程序将要进入活动状态，即将进入前台运行
 说明：当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。*/
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [application cancelAllLocalNotifications];
    
}

/*应用程序已进入前台，处于活动状态
 说明：当应用程序进入活动状态时执行，这个刚好跟上面那个方法相反 。*/
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if (!YDHadLogin) {  return; }
    
    //重新登录xmpp
    [[YDXMPPHelper sharedInstance] loginXmppWithUserId:YDUser_id password:[YDUserDefault defaultUser].user.ub_password];
    
    //请求所有推送消息
    [[YDPushMessageManager sharePushMessageManager] requestPushMessagesByCurrentUserid:[YDUserDefault defaultUser].user.ub_id];
    
    //请求所有系统消息
    [[YDSystemMessageHelper sharedInstance] requestSystemMessagesCompletion:nil];
    
    //动态消息数量
    [[YDMineHelper sharedInstance] requestDynamicMessagesCount];
    
}

/*应用程序将要退出，通常用于保存数据和一些退出前的清理工作
 说明：当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值。*/
- (void)applicationWillTerminate:(UIApplication *)application {
    
    
}

/*iPhone设备只有有限的内存，如果为应用程序分配了太多内存操作系统会终止应用程序的运行，在终止前会执行这个方法，通常可以在这里进行内存清理工作防止程序被终止。*/
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    YDLog();
    
}



@end

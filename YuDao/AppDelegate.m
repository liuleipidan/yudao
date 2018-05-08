//
//  AppDelegate.m
//  YuDao
//
//  Created by 汪杰 on 16/9/7.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "AppDelegate+AppLifeCircle.h"
#import "AppDelegate+ThirdPartSDK.h"
#import "AppDelegate+ThreeDTouch.h"
#import "YDPlacePickerTool.h"
#import "YDLaunchImageAdTool.h"

@interface AppDelegate ()

@property (nonatomic, strong) YDLaunchImageAdTool *launchImageAdTool;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化界面
    [self ad_initUI:launchOptions];
    
    //初始化通知设置
    [self yd_initNotificationSetting:application];
    
    //初始化极光推送
    [self yd_initJPush:launchOptions];
    
    //初始化地点选择器
    [YDPlacePickerTool sharedInstance];
    
    //键盘管理
    [self yd_initIQKeyboardManager];
    
    //开启AFNetworking的菊花效果
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //开启网络监测
    [self startNetworkMonitoring];
    
    //刷新用户token
    [YDNetworking refreshUserToken];
    
    //初始化3Dtouch
    [self yd_init3DTouch];
    
    //可在非主线程初始化的功能
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkVersionUpdate];          //检查app更新
        [self yd_initBaiduMap];             //初始化百度地图
        [self yd_startBaiduAppCount];       //百度app统计
        [YDFriendHelper sharedFriendHelper];//初始化好友数据
        [YDShareManager registerShareSDK];  //注册第三方分享和登录
    });
    
    return YES;
}

#pragma mark - Private Methods
//初始化界面
- (void)ad_initUI:(NSDictionary *)launchOptions{
    
    //状态栏字体颜色，白色
    [[UIApplication sharedApplication] yd_setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //如果用户已经登录，登录xmpp
    if (YDHadLogin) {
        [[YDXMPPHelper sharedInstance] loginXmppWithUserId:[YDUserDefault defaultUser].user.ub_id password:[YDUserDefault defaultUser].user.ub_password];
    }
    
    [self.window makeKeyAndVisible];
    
    //app是否为第一次启动
    if ([YDStandardUserDefaults boolForKey:@"isFirst"]) {
        self.window.rootViewController = self.rootVC;
        YDWeakSelf(self);
        [self.launchImageAdTool showAdImageByDismissBlock:^(YDLaunchImageDismissType dismissType) {
            weakself.launchImageAdTool = nil;
        }];
    }
    else{
        self.window.rootViewController = [YDLaunchViewController new];
    }
}

//初始化通知设置
- (void)yd_initNotificationSetting:(UIApplication *)application{
    dispatch_async(dispatch_get_main_queue(), ^{
        //iOS 10 before
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        
        //iOS 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                YDLog(@"request authorization failure !");
            }
        }];
    });
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//MARK:iOS 9.0及以后被其他app打开的回调
- (BOOL)application:(UIApplication *)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    [YDURLHandle handleOpenURL:url];
    
    return YES;
}
#else
//MARK:iOS 9.0以前被其他app打开的回调
- (BOOL)application:(UIApplication *)application
            openURL:(nonnull NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nonnull id)annotation{
    
    [YDURLHandle handleOpenURL:url];
    
    return YES;
}
#endif

#pragma mark - Getters
- (YDRootViewController *)rootVC{
    return [YDRootViewController sharedRootViewController];
}

- (UIWindow *)window{
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

- (YDLaunchImageAdTool *)launchImageAdTool{
    if (_launchImageAdTool == nil) {
        _launchImageAdTool = [[YDLaunchImageAdTool alloc] init];
    }
    return _launchImageAdTool;
}

@end

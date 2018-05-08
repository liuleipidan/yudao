
//
//  AppDelegate+ThreeDTouch.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/23.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "AppDelegate+ThreeDTouch.h"

@implementation AppDelegate (ThreeDTouch)

//初始化3DTouch
- (void)yd_init3DTouch{
    NSString *platform = [YDShortcutMethod deviceModel];
    
    if ([platform isEqualToString:@"iPhone 6s"] || [platform isEqualToString:@"iPhone 6s Plus"] || [platform isEqualToString:@"iPhone 7"] || [platform isEqualToString:@"iPhone 7 Plus"] || [platform isEqualToString:@"iPhone Simulator"]) {
        /**
         type 该item 唯一标识符
         localizedTitle ：标题
         localizedSubtitle：副标题
         icon：icon图标 可以使用系统类型 也可以使用自定义的图片
         userInfo：用户信息字典 自定义参数，完成具体功能需求
         */
        UIApplicationShortcutIcon *cameraIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
        UIApplicationShortcutItem *cameraItem = [[UIApplicationShortcutItem alloc] initWithType:@"ONE" localizedTitle:@"发个动态" localizedSubtitle:@"" icon:cameraIcon userInfo:nil];
        
        UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
        UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc] initWithType:@"TWO" localizedTitle:@"分享" localizedSubtitle:@"" icon:shareIcon userInfo:nil];
        /** 将items 添加到app图标 */
        [UIApplication sharedApplication].shortcutItems = @[cameraItem,shareItem];
    }
}
//MARK:Icon 3Dtouch 回调
- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler{
    
    if ([shortcutItem.type isEqualToString:@"ONE"]) {
        NSInteger selectedIndex = YDHadLogin ? 1 : 0 ;
        
        self.rootVC.selectedIndex = selectedIndex;
        YDNavigationController *naviVC = self.rootVC.selectedViewController;
        if (YDHadLogin) {
            [naviVC pushViewController:[YDAllDynamicController new] animated:YES];
            YDPublishDynamicController *vc = [YDPublishDynamicController new];
            [naviVC presentViewController:[YDNavigationController createNaviByRootController:vc] animated:YES completion:nil];
        }else{
            [naviVC.visibleViewController presentViewController:[YDLoginViewController new] animated:YES completion:^{
                
            }];
        }
        
    }
    if ([shortcutItem.type isEqualToString:@"TWO"]) {
        NSArray *arr = @[@"遇道"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        //设置当前的VC 为rootVC
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

@end

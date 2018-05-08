//
//  YDNotificationManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/4/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDNotificationManager.h"

@implementation YDNotificationManager

//处理用户点击推送进入app
+ (void)handleUserClickNotification:(NSDictionary *)info{
    YDLog(@"APNS info = %@",info);
    //通知码，用于判断操作内容，具体解释参考YDNotificationManager.h文件
    NSNumber *code = [info objectForKey:@"code"];
    
    //天气
    if (code.integerValue == YDServerMessageTypeWeather) {
        [self userDidClickedNotificationWithParamters:[YDNotificationManager notificationJumpParametersByCode:code]];
    }
    
    //下面操作都需要登录才可进行，若用户未登录直接返回
    if (!YDHadLogin) {  return; }
    YDLog(@"param = %@",[YDNotificationManager notificationJumpParametersByCode:code]);
    //进入对应的界面
    [self userDidClickedNotificationWithParamters:[YDNotificationManager notificationJumpParametersByCode:code]];
    
    //请求所有推送消息
    [[YDPushMessageManager sharePushMessageManager] requestPushMessagesByCurrentUserid:YDUser_id];
    
    //请求所以系统消息
    [[YDSystemMessageHelper sharedInstance] requestSystemMessagesCompletion:nil];
    
    //拉取最新首页消息存入数据库
    [[YDPushMessageManager sharePushMessageManager] post_requestHomePageMessagesByCurrentUserToken:YDAccess_token];
    
    //动态消息数量
    [[YDMineHelper sharedInstance] requestDynamicMessagesCount];
}

//处理非APNS通知
+ (void)handleNoAPNSNofitication:(NSDictionary *)info{
    
    YDLog(@"非APNS info = %@",info);
    
    //下面操作都需要登录才可进行，若用户未登录直接返回
    if (!YDHadLogin) {  return; }
    
    //静默消息内容放在 ”extras“ 里
    NSDictionary *extras = [info valueForKey:@"extras"];
    NSInteger code = [(NSNumber *)[extras valueForKey:@"code"] integerValue];
    
    //账号在其他设备登录
    if (code == YDServerMessageTypeOtherDeviceLogin) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController YD_OK_AlertController:[YDRootViewController sharedRootViewController] title:@"用户已失效\n或在其他设备上登录" clickBlock:^{
                //移除用户信息
                [[YDUserDefault defaultUser] removeUser];
                UIViewController *currentVC = [UIViewController yd_getTheCurrentViewController];
                //如果当前界面非登录界面
                if (currentVC == nil || ![currentVC isKindOfClass:[YDLoginViewController class]]) {
                    if (![currentVC isKindOfClass:[YDLoginViewController class]]) {
                        [[YDRootViewController sharedRootViewController] presentViewController:[YDLoginViewController new] animated:YES completion:^{
                            [[YDRootViewController sharedRootViewController] releaseNavigationControllerAndShowViewControllerWithIndex:0];
                        }];
                    }
                }
            }];
        });
        
    }
    //被对方删除好友
    else if (code == YDServerMessageTypeFriendDeleted) {
        //不用插入数据库，直接return
        NSNumber *ub_id = [extras valueForKey:@"ub_id"];
        [[YDFriendHelper sharedFriendHelper] deleteFriendByFid:ub_id];
        return;
    }
    //动态消息（即当前用户的动态被点赞或评论）
    else if (code == YDServerMessageTypeDynamicMessage) {
        NSNumber *count = [extras valueForKey:@"count"];
        [[YDMineHelper sharedInstance] setDyMsgUnreadCount:count.unsignedIntegerValue];
    }
    else if (code == YDServerMessageTypeCarInforChanged) {
        NSNumber *ub_id = [extras objectForKey:@"ub_id"];
        NSNumber *ug_id = [extras objectForKey:@"ug_id"];
        if ([ub_id isEqual:YDUser_id] && ug_id) {
            [[YDCarHelper sharedHelper] syncServerCarInformation:ug_id success:^(YDCarDetailModel *newCar) {
                
            } failure:^{
                
            }];
        }
    }
    else if (code == YDServerMessageTypeUserInfoChanged) {
        NSNumber *ub_id = [extras objectForKey:@"ub_id"];
        NSLog(@"YDServerMessageTypeUserInfoChanged ub_id = %@",ub_id);
    }
    
}

#pragma mark - Private Methods

/**
 用户点击通知栏进入app

 @param parameters 参数包括 controllerClass:要调入的控制类字符串，topConrollerIndex:模块索引
 */
+ (void)userDidClickedNotificationWithParamters:(NSDictionary *)parameters{
    NSString *controllerClassStr = [parameters valueForKey:@"controllerClass"];
    
    UIViewController *currentVC = [UIViewController yd_getTheCurrentViewController];
    if (parameters == nil ||
        [UIApplication sharedApplication].applicationState == UIApplicationStateActive ||
        [currentVC isKindOfClass:NSClassFromString(controllerClassStr)]) {
        return;
    }
    
    id pushToController = [NSClassFromString(controllerClassStr) new];
    if (pushToController) {
        NSNumber *topConrollerIndex = [parameters valueForKey:@"topConrollerIndex"];
        //释放所有子控制器,并切换到对应的主模块
        [[YDRootViewController sharedRootViewController] releaseNavigationControllerAndShowViewControllerWithIndex:topConrollerIndex.unsignedIntegerValue];
        
        //跳转到相应界面
        [[YDRootViewController sharedRootViewController].selectedViewController pushViewController:pushToController animated:YES];
    }
    
}

#pragma mark - Getters
+ (NSDictionary *)notificationJumpParametersByCode:(NSNumber *)code{
    NSDictionary *jumpParam = nil;
    switch (code.integerValue) {
        case YDServerMessageTypeFriendRequest://好友请求
        {
            jumpParam = @{
                          @"controllerClass":@"YDNewFriendController",
                          @"topConrollerIndex":@3
                          };
            break;}
        case YDServerMessageTypeWeather://天气
        {
            jumpParam = @{
                          @"controllerClass":@"YDWeatherController",
                          @"topConrollerIndex":@0
                          };
            break;}
        case YDServerMessageTypeChatMessage://聊天
        {
            jumpParam = @{
                          @"controllerClass":@"YDConversationController",
                          @"topConrollerIndex":@3
                          };
            break;}
        case YDServerMessageTypeMarketingActivity://活动
        {
            jumpParam = @{
                          @"controllerClass":@"YDActivityViewController",
                          @"topConrollerIndex":@1
                          };
            break;}
        case YDServerMessageTypeCouponSend://卡券
        {
            jumpParam = @{
                          @"controllerClass":@"YDCardPackageController",
                          @"topConrollerIndex":@3
                          };
            break;}
        case YDServerMessageTypeAdviseFeedback://意见反馈
        {
            jumpParam = @{
                          @"controllerClass":@"YDAdviseViewController",
                          @"topConrollerIndex":@3
                          };
            break;}
        case YDServerMessageTypeAvatarVerify://头像审核
        case YDServerMessageTypeIdentityAuth://身份认证
        case YDServerMessageTypeBackgroundVerify://背景审核
        case YDServerMessageTypeCarAuth://车辆认证
        case YDServerMessageTypeIllegal://违章
        case YDServerMessageTypeTaskFinished://任务完成
        case YDServerMessageTypeIntegralChanged://积分变动
        case YDServerMessageTypeDailyPush://每日推送
        case YDServerMessageTypeServerPush://服务推送
        case YDServerMessageTypeLikedCurrentUser://有人喜欢我
        {
            jumpParam = @{
                          @"controllerClass":@"YDSystemMessageController",
                          @"topConrollerIndex":@3
                          };
            break;}
        default:
            jumpParam = nil;
            break;
    }
    return jumpParam;
}

@end

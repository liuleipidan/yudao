//
//  YDNotificationManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/4/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDNotificationManager : NSObject

/**
 处理用户点击推送进入app

 @param info 推送信息
 */
+ (void)handleUserClickNotification:(NSDictionary *)info;

/**
 处理非APNS通知

 @param info 通知内容
 */
+ (void)handleNoAPNSNofitication:(NSDictionary *)info;


@end

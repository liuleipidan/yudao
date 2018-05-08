//
//  YDUserDefaultsManager.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 存储多个用户在当前设备的信息数组 -- start
/*
 包含信息
 UserDefaults:{
     kUsersLocalInformationArray:[
        kUserLocalInfoKeyPrefix_UserId:{
             kUserDailyLoginDateKey:@1524464691
        }
     ]
 }
 */
//多用户本地信息
#define kUsersLocalInfoKey     @"kUsersLocalInformationKey"

//用户本地信息Key头
#define kUserLocalInfoKeyPrefix  @"kUserLocalInfoKeyPrefix_%@"

//记录每日登陆的时间，key用户标志standardUserDefaults
#define kUserDailyLoginDateKey   @"kUserDailyLoginDateKey"

//用户动态标签历史记录
#define kUserDynamicLabelsHistoryKey   @"kUserDynamicLabelsHistoryKey"

//极光推送
#define kJPushRegistrationIDKey  @"kJPushRegistrationIDKey"

#pragma mark - 存储多个用户在当前设备的信息数组 -- end

@interface YDUserDefaultsManager : NSObject

//用户的动态历史标签
@property (nonatomic, strong) NSMutableArray *dynamicLabelHistory;

+ (YDUserDefaultsManager *)manager;

- (BOOL)isFirstDailyLogin;

- (void)insertUserDynamicLabel:(NSString *)label;

- (void)removeHistoryLabelsByLabel:(NSString *)label;

@end

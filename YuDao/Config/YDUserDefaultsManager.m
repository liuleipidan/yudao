//
//  YDUserDefaultsManager.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDUserDefaultsManager.h"

@interface YDUserDefaultsManager()

@property (nonatomic, strong) NSMutableDictionary *usersLocalInfoDic;

@property (nonatomic, strong) NSMutableDictionary *userInfo;

@end

@implementation YDUserDefaultsManager

+ (YDUserDefaultsManager *)manager{
    return [[YDUserDefaultsManager alloc] init];
}

- (BOOL)isFirstDailyLogin{
    NSDate *date = [self dailyLoginDate];
    if (date == nil) {
        [self upateDailyLoginDate];
        return YES;
    }
    if (![date isToday]) {
        [self upateDailyLoginDate];
        return YES;
    }
    return NO;
}

- (NSDate *)dailyLoginDate{
    return [self.userInfo objectForKey:kUserDailyLoginDateKey];
}

- (void)upateDailyLoginDate{
    [self.userInfo setObject:[NSDate date] forKey:kUserDailyLoginDateKey];
    [self updateUserInfo];
}

//更新本地数据
- (void)updateUserInfo{
    [self.usersLocalInfoDic setObject:self.userInfo forKey:[NSString stringWithFormat:kUserLocalInfoKeyPrefix,YDUser_id]];
    [[NSUserDefaults standardUserDefaults] setObject:self.usersLocalInfoDic forKey:kUsersLocalInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//删除用户动态历史标签
- (void)removeHistoryLabelsByLabel:(NSString *)label{
    [self.dynamicLabelHistory enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:label]) {
            [self.dynamicLabelHistory removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.userInfo setObject:self.dynamicLabelHistory forKey:kUserDynamicLabelsHistoryKey];
    [self updateUserInfo];
}

//插入用户动态历史标签
- (void)insertUserDynamicLabel:(NSString *)label{
    [self.dynamicLabelHistory enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:label]) {
            [self.dynamicLabelHistory removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.dynamicLabelHistory insertObject:label atIndex:0];
    if (self.dynamicLabelHistory.count > 10) {
        [self.dynamicLabelHistory removeObjectsInRange:NSMakeRange(10, self.dynamicLabelHistory.count-10)];
    }
    [self.userInfo setObject:self.dynamicLabelHistory forKey:kUserDynamicLabelsHistoryKey];
    [self updateUserInfo];
}

#pragma mark - Getters
- (NSMutableArray *)dynamicLabelHistory{
    if (_dynamicLabelHistory == nil) {
        NSMutableArray *tempArr = [self.userInfo objectForKey:kUserDynamicLabelsHistoryKey];
        if (tempArr) {
            _dynamicLabelHistory = [tempArr mutableCopy];
        }
        else{
            _dynamicLabelHistory = [NSMutableArray array];
        }
    }
    return _dynamicLabelHistory;
}

- (NSMutableDictionary *)userInfo{
    if (_userInfo == nil) {
        NSString *userKey = [NSString stringWithFormat:kUserLocalInfoKeyPrefix,YDUser_id];
        NSDictionary *tempDic = [self.usersLocalInfoDic objectForKey:userKey];
        if (tempDic == nil) {
            tempDic = [NSMutableDictionary dictionary];
            [self.usersLocalInfoDic setObject:tempDic forKey:userKey];
            [[NSUserDefaults standardUserDefaults] setObject:self.usersLocalInfoDic forKey:kUsersLocalInfoKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _userInfo = [tempDic mutableCopy];
    }
    return _userInfo;
}

- (NSMutableDictionary *)usersLocalInfoDic{
    if (_userInfo == nil) {
        NSMutableDictionary *tempDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUsersLocalInfoKey];
        
        if (tempDic == nil) {
            tempDic = [NSMutableDictionary dictionary];
            [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:kUsersLocalInfoKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _usersLocalInfoDic = [tempDic mutableCopy];
    }
    return _usersLocalInfoDic;
}

@end

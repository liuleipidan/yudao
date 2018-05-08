//
//  YDTrafficInfoManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTrafficInfoManager.h"

#define kCarInformationURL [kOriginalURL stringByAppendingString:@"obdweek"]

@interface YDTrafficInfoManager()

/**
 当前车辆数据
 */
@property (nonatomic, strong) NSMutableDictionary *currentCarData;

@end

@implementation YDTrafficInfoManager

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)requestCarDataCompletion:(void (^)(NSNumber *code,NSString *status))completion{
    if (self.currentCar.ug_id == nil ||
        [self.currentCar.ug_id isEqual:@0]) {
        return;
    }
    YDWeakSelf(self);
    NSDictionary *para = @{
                           @"access_token":YDAccess_token,
                           @"ug_id":self.currentCar.ug_id
                           };
    YDLog(@"CarData_para = %@",para);
    [YDNetworking GET:kCarInformationURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"car data = %@",data);
        [weakself setCurrentCarData:data];;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(trafficInfoManager:requestCarDataCompletion:)]) {
            [self.delegate trafficInfoManager:self requestCarDataCompletion:code];
        }
        
        if (completion) {
            completion(code,status);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Setters
- (void)setCurrentCar:(YDCarDetailModel *)currentCar{
    if ((_currentCar == nil && currentCar) ||
        (![_currentCar.ug_id isEqual:currentCar.ug_id] && currentCar) ||
        (_currentCar.boundDeviceType != currentCar.boundDeviceType && currentCar)) {
        _currentCar = currentCar;
        if (_delegate && [_delegate respondsToSelector:@selector(trafficInfoManager:currentCarDidChanged:)]) {
            [_delegate trafficInfoManager:self currentCarDidChanged:currentCar];
        }
    }
    _currentCar = currentCar;
}
- (void)setCurrentCarData:(NSMutableDictionary *)currentCarData{
    _currentCarData = currentCarData;
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ve-link.YuDaoApp"];
    [shared setObject:self.oilwear forKey:@"oilWear"];
    [shared setObject:self.mileage forKey:@"mileage"];
    [shared setObject:self.score forKey:@"test"];
    [shared setObject:YDNoNilNumber([YDCarHelper sharedHelper].defaultCar.ug_boundtype) forKey:@"boundtype"];
    [shared synchronize];
}

#pragma mark - Getters
- (BOOL)veBoxIsBound{
    NSNumber *ug_boundtype = [self.currentCarData objectForKey:@"ug_boundtype"];
    return [ug_boundtype isEqual:@1];
}

- (BOOL)veAirIsBound{
    NSNumber *ug_bind_air = [self.currentCarData objectForKey:@"ug_bind_air"];
    return [ug_bind_air isEqual:@1];
}

- (NSString *)score{
    NSNumber *score = [self.currentCarData objectForKey:@"ug_health"];
    return [NSString stringWithFormat:@"%@",score ? : @0];
}

- (NSString *)mileage{
    NSNumber *mileage = [self.currentCarData objectForKey:@"weekmileage"];
    return [NSString stringWithFormat:@"%.1fKM",mileage ? mileage.floatValue : 0.f];
}

- (NSString *)oilwear{
    NSNumber *oilwear = [self.currentCarData objectForKey:@"weekfuel"];
    return [NSString stringWithFormat:@"%.1fL",oilwear ? oilwear.floatValue : 0.f];
}

- (NSString *)rank{
    NSNumber *rank = [self.currentCarData objectForKey:@"ranking"];
    if (rank == nil || [rank isEqual:@0]) {
        return @"暂无排名";
    }
    return [NSString stringWithFormat:@"昨日里程排名%@",rank];
}

- (NSString *)rankingImageStr{
    NSString *str = @"cardriving_rank_normal";
    NSNumber *change = [self.currentCarData objectForKey:@"change"];
    switch (change.integerValue) {
        case 1:
            str = @"cardriving_rank_up";
            break;
        case 2:
            str = @"cardriving_rank_down";
            break;
        default:
            break;
    }
    return str;
}

- (NSString *)outsideAQI{
    NSNumber *aqi = [self.currentCarData objectForKey:@"aqi"];
    return [NSString stringWithFormat:@"%@",aqi ? : @0];
}

@end

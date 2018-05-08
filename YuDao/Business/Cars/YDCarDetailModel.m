//
//  YDCarDetailModel.m
//  YuDao
//
//  Created by 汪杰 on 16/11/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDCarDetailModel.h"

@implementation YDCarDetailModel


+ (NSArray *)mj_ignoredPropertyNames{
    return @[
             @"airChannelId",
             @"air_imei",
             @"air_mac",
             @"air_identifier",
             @"airNextCleaningTime"
             ];
}

+ (YDCarDetailModel *)ranklistCreatModel:(NSString *)imageName title:(NSString *)title slectedIndex:(NSInteger )index{
    YDCarDetailModel *model =  [YDCarDetailModel new];
    model.ug_brand_logo = imageName;
    model.ug_brand_name = title;
    model.ug_status = @(index);
    
    return model;
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if (property.type.typeClass == [NSString class]) {
        if (!oldValue || oldValue == NULL || oldValue == nil) {
            return @"";
        }
    }
    if (property.type.typeClass == [NSNumber class]) {
        if ([oldValue  isEqual: @""] || !oldValue || oldValue == NULL || oldValue == nil ) {
            return @0;
        }
//        NSNumber * num = oldValue;
//        if (num.integerValue < 0) {
//            return @0;
//        }
    }
    
    return oldValue;
    
}

- (NSString *)vehicle_authStatus{
    NSString *auth = nil;
    switch (self.ug_vehicle_auth.integerValue) {
        case 0:
            auth = @"未认证";
            break;
        case 1:
            auth = @"已认证";
            break;
        case 2:
            auth = @"认证中";
            break;
        default:
            auth = @"认证失败";
            break;
    }
    return auth;
}

#pragma mark - Getters
- (YDCarBoundDeviceType)boundDeviceType{
    BOOL box = [self.ug_boundtype isEqual:@1];
    BOOL air = [self.ug_bind_air isEqual:@1];
    if (box && air) {
        return YDCarBoundDeviceTypeBOX_AIR;
    }
    else if (box && !air){
        return YDCarBoundDeviceTypeVE_BOX;
    }
    else if (!box && air){
        return YDCarBoundDeviceTypeVE_AIR;
    }
    return YDCarBoundDeviceTypeNone;
}

- (NSNumber *)airChannelId{
    return [self.airInfo objectForKey:@"channelidair"] ? : @0;
}

- (NSNumber *)air_imei{
    return [self.airInfo objectForKey:@"air_imei"] ? : @0;
}

- (NSString *)air_mac{
    return [self.airInfo objectForKey:@"air_mac"] ? : @"";
}

- (NSString *)air_identifier{
    return [self.airInfo objectForKey:@"air_identifier"] ? : @"";
}

- (NSNumber *)airNextCleaningTime{
    return [self.airInfo objectForKey:@"ug_next_cleaning_time"] ? : @0;
}

@end

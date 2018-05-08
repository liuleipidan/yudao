//
//  YDCard.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCard.h"

@implementation YDCard

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"couponId":@"coupon_id",
             @"secret":@"ticket",
             @"startTime":@"expires_start_at",
             @"endTime":@"expires_end_at"
             };
}

#pragma mark - Getters
- (NSString *)typeTitle{
    static NSDictionary *typeTempDic = nil;
    if (typeTempDic == nil) {
        typeTempDic = @{
                        @1:@"车",
                        @2:@"游",
                        @3:@"食"
                        };
    }
    return typeTempDic[self.category] ? : @"车";
}

- (NSString *)statusIconPath{
    if (self.isExpired) {
        return @"mine_coupon_status_expired";
    }
    static NSDictionary *statusTempDic = nil;
    if (statusTempDic == nil) {
        statusTempDic = @{
                          @0:@"mine_coupon_status_expired",
                          @1:@"mine_coupon_status_normal",
                          @2:@"mine_coupon_status_used",
                          @3:@"mine_coupon_status_invaild"
                          };
    }
    return statusTempDic[self.status] ? : @"mine_coupon_status_normal";
}

- (BOOL)isExpired{
    if ([self.expires isEqual:@0]) {
        return NO;
    }
    NSDate *now = [NSDate date];
    NSDate *end = [NSDate dateFromTimeStamp:self.endTime];
    return [end isEqual:[end earlierDate:now]];
}

- (NSString *)imageURL{
    if (_imageURL == nil) {
        NSArray *tempArr = [self.img componentsSeparatedByString:@","];
        if (tempArr.count == 3) {
            _imageURL = tempArr.firstObject;
            _imageWidth = [[tempArr objectAtIndex:1] floatValue];
            _imageHeight = [tempArr.lastObject floatValue];
        }
    }
    return _imageURL;
}

@end

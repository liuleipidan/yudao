//
//  NSString+RegularExpressionConfig.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/27.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "NSString+RegularExpressionConfig.h"
#import "YDRegularExpressoinConfig.h"

@implementation NSString (RegularExpressionConfig)

- (YDScannerResultType)re_validateScanResult{
    
    NSArray<NSString *> *matchArr = @[
                                      SCAN_RESULT_MATCH_USER,
                                      SCAN_RESULT_MATCH_HTTP,
                                      SCAN_RESULT_MATCH_VE_BOX,
                                      SCAN_RESULT_MATCH_VE_AIR
                                      ];
    __block YDScannerResultType type = YDScannerResultTypeUnknown;
    [matchArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self rec_validateByCondition:obj]) {
            type = (YDScannerResultType)(idx + 1);
            *stop = YES;
        }
    }];
    return type;
}

- (BOOL)re_validateDeviceIMei_VE_BOX{
    return [self rec_validateByCondition:DEVICE_IMEI_VE_BOX];
}

- (BOOL)re_validateDeviceIMei_VE_AIR{
    return [self rec_validateByCondition:DEVICE_IMEI_VE_AIR];
}

/*
 * 是否为车牌号
 */
- (BOOL)re_validatePlateNumber{
    return [self rec_validateByCondition:PLATE_NUMBER];
}

/*
 * 是否为邀请码
 */
- (BOOL)re_validateInvitaionNumber{
    return [self rec_validateByCondition:INVITAION_NUMBER];
}

- (BOOL)re_validateEmptyString{
    if (!self) {
        return true;
    }
    else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        }
        else {
            return false;
        }
    }
}

#pragma mark - Private Methods
- (BOOL)rec_validateByCondition:(NSString *)conditoin{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:MATCH_PREFIX, conditoin];
    return [predicate evaluateWithObject:self];
}

@end

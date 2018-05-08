//
//  YDCarSeries.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarSeries.h"
#import "NSString+PinYin.h"

@implementation YDCarSeries

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"firstletter":@"vs_firstletter"
             };
}

#pragma mark - YDCarModelProtocol
- (NSString *)nameFirstWord{
    if (self.firstletter.length > 0) {
        return self.firstletter;
    }
    return self.vs_name.pinyinInitial;
}



@end

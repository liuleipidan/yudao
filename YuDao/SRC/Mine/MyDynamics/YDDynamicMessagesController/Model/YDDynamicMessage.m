//
//  YDDynamicMessage.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDynamicMessage.h"

@implementation YDDynamicMessage

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"type":@"label",
             @"conmentContent":@"cd_details",
             @"status":@"cd_status",
             @"nickName":@"nickname"
             };
}

@end

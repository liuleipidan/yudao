//
//  YDLikePersonModel.m
//  YuDao
//
//  Created by 汪杰 on 16/11/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDLikePersonModel.h"

@implementation YDLikePersonModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if (property.type.typeClass == [NSString class]) {
        if (!oldValue) {
            return @"";
        }
    }
    if (property.type.typeClass == [NSNumber class]) {
        if ([oldValue  isEqual: @""] || !oldValue) {
            return @0;
        }
        NSNumber * num = oldValue;
        if (num.integerValue < 0) {
            return @0;
        }
    }
    
    return oldValue;

}

@end

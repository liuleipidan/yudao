//
//  YDDynamicMessageHelper.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDynamicMessageHelper.h"


static YDDynamicMessageHelper *dynamicMessageHelper = nil;

@implementation YDDynamicMessageHelper

+ (YDDynamicMessageHelper *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dynamicMessageHelper = [[YDDynamicMessageHelper alloc] init];
    });
    return dynamicMessageHelper;
}

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}



@end

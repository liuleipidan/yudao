//
//  YDSystemTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSystemTool.h"

@implementation YDSystemTool

+ (void)st_callToSomeOneWithPhone:(NSString *)phone{
    if (phone.length == 0) {
        return;
    }
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",phone];
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

@end

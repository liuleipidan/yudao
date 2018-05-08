//
//  UIScrollView+YuDao.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "UIScrollView+YuDao.h"

@implementation UIScrollView (YuDao)

- (void)yd_setContentInsetAdjustmentBehavior:(NSInteger)behavior{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {
        NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        NSInteger argument = behavior;
        invocation.target = self;
        invocation.selector = @selector(setContentInsetAdjustmentBehavior:);
        [invocation setArgument:&argument atIndex:2];
        [invocation retainArguments];
        [invocation invoke];
    }
#pragma clang diagnostic pop
}

@end

//
//  UIApplication+Category.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "UIApplication+Category.h"

@implementation UIApplication (Category)

- (void)yd_setStatusBarStyle:(UIStatusBarStyle)style{
    [self yd_setStatusBarStyle:style animated:YES];
}

- (void)yd_setStatusBarStyle:(UIStatusBarStyle)style animated:(BOOL)animated{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self setStatusBarStyle:style animated:YES];
#pragma clang diagnostic pop
    
}

- (void)yd_setStatusBarHidden:(BOOL)hide{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:hide];
#pragma clang diagnostic pop
}

@end

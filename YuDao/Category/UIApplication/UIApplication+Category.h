//
//  UIApplication+Category.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Category)

- (void)yd_setStatusBarStyle:(UIStatusBarStyle)style;

- (void)yd_setStatusBarStyle:(UIStatusBarStyle)style animated:(BOOL)animated;

- (void)yd_setStatusBarHidden:(BOOL)hide;

@end

//
//  UIViewController+Extension.h
//  YuDao
//
//  Created by 汪杰 on 17/1/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)yd_getTheCurrentViewController;

- (void)yd_pushViewControllerWithString:(NSString *)vcClassName;

/**
 设置状态栏背景颜色

 @param color 背景色   
 */
+ (void)setStatusBarBackgroundColor:(UIColor *)color;

@end

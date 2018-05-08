//
//  UIAlertController+Extension.h
//  YuDao
//
//  Created by 汪杰 on 16/12/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)


/**
 弹出提示框

 @param preViewController 弹出的主视图,如果空则取当前视图控制器
 @param title 主标题
 @param subTitle 子描述
 @param items 按钮数组，两个及以上则竖向排列
 @param style 样式
 @param block 点击回调（0->取消,其他一次递增）
 */
+ (void)YD_alertController:(UIViewController *)preViewController
                     title:(NSString *)title
                  subTitle:(NSString *)subTitle
                     items:(NSArray <NSString *> *) items
                     style:(UIAlertControllerStyle )style
                clickBlock:(void (^)(NSInteger index))block;

//只是用来提示的框(确认)
+ (void)YD_OK_AlertController:(UIViewController *)preViewController
                        title:(NSString *)title
                   clickBlock:(void (^)(void))block;


+ (void)YD_OK_AlertController:(UIViewController *)preViewController
                        title:(NSString *)title
                      message:(NSString *)message
                   clickBlock:(void (^)(void))block;

@end

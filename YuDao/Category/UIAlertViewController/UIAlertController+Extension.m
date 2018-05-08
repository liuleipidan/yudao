//
//  UIAlertController+Extension.m
//  YuDao
//
//  Created by 汪杰 on 16/12/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)

/**
 弹出Alert框(点击的回调0->取消，其他按items依次递增)

 @param preViewController 弹出的当前控制器
 @param title 标题
 @param subTitle 自标题
 @param items 按钮数组
 @param style alert样式
 @param block 点击回调
 */
+ (void)YD_alertController:(UIViewController *)preViewController
                     title:(NSString *)title
                   subTitle:(NSString *)subTitle
                      items:(NSArray <NSString *> *) items
                      style:(UIAlertControllerStyle )style
                 clickBlock:(void (^)(NSInteger index))block{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:style];
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(idx+1);
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertC addAction:action];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block(0);
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:cancelAction];
    if (!preViewController) {
        preViewController = [UIViewController yd_getTheCurrentViewController];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [preViewController presentViewController:alertC animated:YES completion:nil];
    });
}

+ (void)YD_OK_AlertController:(UIViewController *)preViewController
                        title:(NSString *)title
                         clickBlock:(void (^)(void))block{
    [self YD_OK_AlertController:preViewController title:title message:nil clickBlock:block];
}

+ (void)YD_OK_AlertController:(UIViewController *)preViewController
                        title:(NSString *)title
                      message:(NSString *)message
                   clickBlock:(void (^)(void))block{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
        if (block) {
            block();
        }
    }];
    [alertC addAction:okAction];
    if (!preViewController) {
        preViewController = [UIViewController yd_getTheCurrentViewController];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [preViewController presentViewController:alertC animated:YES completion:nil];
    });
}

@end

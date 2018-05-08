//
//  YDPopViewTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDPopViewTool : NSObject

/**
 弹出视图

 @param contentView 需要展示的视图
 */
+ (void)showWithContentView:(UIView *)contentView;

/**
 隐藏视图
 */
+ (void)dismissView;

@end

//
//  UIBarButtonItem+Extension.h
//  YuDao
//
//  Created by 汪杰 on 16/12/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (id)fixItemSpace:(CGFloat)space;

/**
 往左偏移的item

 @param imageStr 图片
 @return item
 */
+ (instancetype)itemOffsetLeftWith:(NSString *)imageStr
                            target:(id)target
                            action:(SEL)action;
/**
 往右偏移的item
 
 @param imageStr 图片
 @return item
 */
+ (instancetype)itemOffsetRightWith:(NSString *)imageStr
                             target:(id)target
                             action:(SEL)action;

//自定义生成方式
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

#pragma mark - 使用系统默认生成方式
//文字
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
//图片
+ (instancetype)itemWithImage:(NSString *)image target:(id)target action:(SEL)action;
//返回
- (id)initWithBackTitle:(NSString *)title target:(id)target action:(SEL)action;

@end

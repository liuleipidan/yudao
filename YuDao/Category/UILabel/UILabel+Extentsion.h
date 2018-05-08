//
//  UILabel+Extentsion.h
//  YuDao
//
//  Created by 汪杰 on 17/1/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extentsion)

+ (UILabel *)labelByTextColor:(UIColor *)textColor font:(UIFont *)font;

+ (UILabel *)labelByTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment;

+ (UILabel *)labelByTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment backgroundColor:(UIColor *)backgroundColor;

//设置文字加行间距
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

//后两位变大
- (void)setLabelAttributeWithContent:(NSString *)content footString:(NSString *)footString;

/**
 设置文字，后两位小

 @param text 字符串
 @param lineSpace 行间距
 */
- (void)yd_setText:(NSString *)text lineSpace:(CGFloat)lineSpace;

//设置多颜色文字
- (void)yd_setText:(NSString *)text color1:(UIColor *)color1 color2:(UIColor *)color2;

@end

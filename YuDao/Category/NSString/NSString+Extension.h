//
//  NSString+Extension.h
//  YuDao
//
//  Created by 汪杰 on 17/2/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 字符串高度
 */
- (CGFloat)yd_stringHeightBySize:(CGSize)size font:(UIFont *)font;

/**
 字符串宽度
 */
- (CGFloat)yd_stringWidthBySize:(CGSize)size font:(UIFont *)font;

/**
 字符串高度,多属性，例如带有行高
 */
- (CGFloat)yd_stringHeightBySize:(CGSize)size attributes:(NSDictionary *)attributes;

/*
 * 将字符串进行URL转码，以防字符中有中文等特殊字符导致访问失败
 */
- (NSString *)yd_URLEncode;

/*
 * 判断是不是手机号码
 */
- (BOOL)isMobileNumber;

/*
 * 根据code获取天气图片，type ( 0->首页天气小图标 1->天气主界面图标 )
 */
- (NSString *)weatherImagePathByWeatherCode:(NSString *)code;

/**
 字符串的长度，中文算两个，其他的统一算一个长度

 @return 字符串长度
 */
- (NSUInteger)textLength;

/**
 移除特殊字符
 */
+ (NSString *)removeSpecialCharacter:(NSString *)str;

@end

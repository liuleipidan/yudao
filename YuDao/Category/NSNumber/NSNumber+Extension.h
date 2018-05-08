//
//  NSNumber+Extension.h
//  YuDao
//
//  Created by 汪杰 on 16/12/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Extension)

/**
 *  返回时间字符串
 *
 *  @return 返回时间字符串
 */
- (NSString *)timeString;

/**
 *  将NSNumber转成一位小数字符串
 *
 *  @return 一位小数字符串
 */
- (NSString *)getOneDecimalString;

@end

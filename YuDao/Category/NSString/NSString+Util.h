//
//  NSString+Util.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/31.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

/*
 * 去除首位空格和换行
 */
- (NSString *)yd_trimWhitespaceAndNewLine;

/*
 * 去除所有空格
 */
- (NSString *)yd_trimAllWhitespace;

/**
 去除首部连续字符（如空格）
 */
- (NSString *)yd_stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;

/**
 去除尾部连续字符（如空格）
 */
- (NSString *)yd_stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

/**
 从URL的query里解出参数字典,例如：name=xx&age=yy
 
 @param query url.query
 @return 参数
 */
+ (NSMutableDictionary *)yd_paramForURLQuery:(NSString *)query;

/**
 NSNumber 转成 NSString 保留小数，并且不四舍五入
 */
//+ (NSString *)yd_

/**
 NSData -> NSString (16进制)
 */
+ (NSString*)coverFromDataToHexStr:(NSData *)data;

@end

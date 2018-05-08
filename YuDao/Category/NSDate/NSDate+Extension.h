//
//  NSDate+Extension.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/4/25.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 计算时间差值类型
 */
typedef NS_ENUM(NSInteger, YDDifferDateType) {
    YDDifferDateTypeSecond = 0,
    YDDifferDateTypeMinute,
    YDDifferDateTypeHour,
    YDDifferDateTypeDay,
    YDDifferDateTypemonth,
    YDDifferDateTypeYear,
};

@interface NSDate (Extension)

/**
 计算时间差值，date1 - date2

 @param date1 时间1
 @param date2 时间2
 @param ditterType 相差类型
 @return 差值
 */
+ (NSUInteger)differFirstDate:(NSDate *)date1
                   secondDate:(NSDate *)date2
                   differType:(YDDifferDateType )ditterType;

/**
 时间戳转NSDate

 @param timeStamp 十位时间戳字符串
 @return NSDate
 */
+ (NSDate *)dateFromTimeStamp:(id)timeStamp;

/**
 yyyy-MM-dd HH:mm:ss转时间字符串
 当天显示hh:mm，当年非当天显示xx月xx日，非当前显示xxxx年xx月xx日
 */
+ (NSString *)yd_timeInformationFromyyyyMMddHHmmss:(NSString *)ymdhsString;

/**
 时间戳转时间字符串
 当天显示hh:mm，当年非当天显示xx月xx日，非当前显示xxxx年xx月xx日
 */
+ (NSString *)yd_timeInformationFromTimestamp:(NSString *)timeStamp;

//同上
+ (NSString *)yd_timeInformationFromDate:(NSDate *)date;

/**
 NSDate转十位时间长字符串

 @return NSDate
 */
- (NSString *)timeStampFromDate;

/**
 * 获取日、月、年、小时、分钟、秒
 */
- (NSUInteger)day;
- (NSUInteger)month;
- (NSUInteger)year;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)second;
+ (NSUInteger)day:(NSDate *)date;
+ (NSUInteger)month:(NSDate *)date;
+ (NSUInteger)year:(NSDate *)date;
+ (NSUInteger)hour:(NSDate *)date;
+ (NSUInteger)minute:(NSDate *)date;
+ (NSUInteger)second:(NSDate *)date;



/**
 * 获取格式化为 YYYY年MM月dd日 格式的日期字符串
 */
- (NSString *)formatYMD;
- (NSString *)formatYMDWith:(NSString *)c;

- (NSString *)formatHM;

/**
 * 获取格式化为 YYYY.MM.dd 格式的日期字符串
 */
+ (NSString *)formatYear_Month_Day:(id)time;

/**
 获取格式化为 YYYY-MM-dd hh:mm:ss 格式的日期字符串
 */
+ (NSString *)format_yyyy_mm_dd_hh_mm_ss:(NSNumber *)timeStamp;

/**
 *  获取星期几
 */
- (NSInteger)weekday;
+ (NSInteger)weekday:(NSDate *)date;

/**
 *  获取星期几(名称)
 */
- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;

/**
 *  Add days to self
 *
 *  @param days The number of days to add
 *  @return Return self by adding the gived days number
 */
- (NSDate *)dateByAddingDays:(NSUInteger)days;

/**
 * 获取月份
 */
+ (NSString *)monthWithMonthNumber:(NSInteger)month;

/**
 * 根据日期返回字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;

+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;

/**
 * 获取指定月份的天数
 */
- (NSUInteger)daysInMonth:(NSUInteger)month;
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month;

/**
 * 获取当前月份的天数
 */
- (NSUInteger)daysInMonth;
+ (NSUInteger)daysInMonth:(NSDate *)date;

/**
 * 返回x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)timeInfo;
+ (NSString *)timeInfoWithDate:(id)unknownDate;
+ (NSString *)timeInfoWithDateString:(NSString *)dateString;

@end

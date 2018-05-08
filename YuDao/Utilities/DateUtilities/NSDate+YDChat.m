//
//  NSDate+TLChat.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/3.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "NSDate+YDChat.h"

@implementation NSDate (YDChat)

//字符串转NSDate,例如yyyy-MM-dd HH:mm:ss-NSDate
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)chatTimeInfo
{
    if ([self isToday]) {       // 今天
        return self.formatHM;
    }
    else if ([self isYesterday]) {      // 昨天
        return [NSString stringWithFormat:@"昨天 %@", self.formatHM];
    }
    else if ([self isThisWeek]){        // 本周
        return [NSString stringWithFormat:@"%@ %@", self.dayFromWeekday, self.formatHM];
    }
    else {
        return [NSString stringWithFormat:@"%@ %@", self.formatYMD, self.formatHM];
    }
}

- (NSString *)conversaionTimeInfo
{
    if ([self isToday]) {
        YDLog(@"今天");// 今天
        return self.formatHM;
    }
    else if ([self isYesterday]) {
        YDLog(@"昨天");// 昨天
        return @"昨天";
    }
    else if ([self isThisWeek]){
        YDLog(@"本周");// 本周
        return self.dayFromWeekday;
    }
    else {
        YDLog(@"其他的日期");
        return [self formatYMDWith:@"/"];
    }
}



- (NSString *)chatFileTimeInfo
{
    if ([self isThisWeek]) {
        return @"本周";
    }
    else if ([self isThisMonth]) {
        return @"这个月";
    }
    else {
        return [NSString stringWithFormat:@"%ld年%ld月", (long)self.year, (long)self.month];
    }
}

//计算星座
+ (NSString *)calculateConstellationWithDate:(NSDate *)date
{
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];//日历
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    NSInteger month = components.month;
    NSInteger day = components.day;
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }
    else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}

@end

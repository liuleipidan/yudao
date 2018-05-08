//
//  NSNumber+Extension.m
//  YuDao
//
//  Created by 汪杰 on 16/12/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

- (NSString *)timeString{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM.dd"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)getOneDecimalString{
    NSString *temString = [NSString stringWithFormat:@"%f",self.floatValue/1000];
    NSRange range = [temString rangeOfString:@"."];
    NSString *result = [[temString substringWithRange:NSMakeRange(0, range.location+2)] stringByAppendingString:@"L"];
    if (result) {
        return  result;
    }
    return @"~L";
}

@end

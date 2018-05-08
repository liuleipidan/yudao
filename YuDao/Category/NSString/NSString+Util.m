//
//  NSString+Util.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/31.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (NSString *)yd_trimWhitespaceAndNewLine{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)yd_trimAllWhitespace{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)yd_stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer range:NSMakeRange(0, length)];
    
    for (NSInteger i = 0; i < length; i++) {
        if (![characterSet characterIsMember:charBuffer[i]]) {
            location = i;
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)yd_stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer range:NSMakeRange(0, length)];
    
    NSUInteger subLength = 0;
    for (NSInteger i = length; i > 0; i--) {
        if (![characterSet characterIsMember:charBuffer[i - 1]]) {
            subLength = i;
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(0, subLength)];
}

+ (NSMutableDictionary *)yd_paramForURLQuery:(NSString *)query{
    if (query == nil) {
        return nil;
    }
    NSArray *array = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:array.count];
    for (NSString *value in array) {
        NSArray *temp = [value componentsSeparatedByString:@"="];
        if (temp.count == 2) {
            [dic setObject:temp.lastObject forKey:temp.firstObject];
        }
    }
    return dic;
}

+(NSString*)coverFromDataToHexStr:(NSData *)data{
    
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    NSUInteger dataLength = [data length];
    
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    return [NSString stringWithString:hexString];
    
}

@end

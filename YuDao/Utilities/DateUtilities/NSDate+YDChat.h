//
//  NSDate+TLChat.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/3.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Extension.h"
#import "NSDate+Utilities.h"

@interface NSDate (YDChat)

- (NSString *)chatTimeInfo;

- (NSString *)conversaionTimeInfo;

- (NSString *)chatFileTimeInfo;

//字符串转NSDate
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format;

//计算星座
+ (NSString *)calculateConstellationWithDate:(NSDate *)date;

@end

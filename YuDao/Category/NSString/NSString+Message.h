//
//  NSString+Message.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/8.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Message)

- (NSAttributedString *)toMessageString;

+ (BOOL)deleteEmojiString:(NSString *)text
               completoin:(void (^)(BOOL ok, NSString *text))completoin;

@end

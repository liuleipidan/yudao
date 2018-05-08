//
//  YDChatMessageProtocol.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YDChatMessageProtocol <NSObject>

/**
 用于返回消息列表显示的内容
 */
- (NSString *)conversationContent;

/**
 消息内容转换，如：字典转json字符串
 */
- (NSString *)messageCopy;

@end

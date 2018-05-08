//
//  YDChatHelperDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YDChatHelperDelegate <NSObject>

@optional

/**
 发送消息成功
 */
- (void)chatMessageSendSuccess:(NSString *)msgId;
/**
 发送消息失败
 */
- (void)chatMessageSendFail:(NSString *)msgId;
/**
 接受到消息
 */
- (void)receiveChatMessage:(YDChatMessage *)message;
/**
 未读聊天信息数量改变
 */
- (void)unreadChatMessageCountHadChanged;
/**
 消息界面改变
 */
- (void)conversationHadChanged;

@end

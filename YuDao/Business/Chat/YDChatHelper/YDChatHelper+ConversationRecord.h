//
//  YDChatHelper+ConversationRecord.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatHelper.h"
#import "YDConversation.h"

@interface YDChatHelper (ConversationRecord)

//所有聊天记录
- (void)getAllConversaionRecord:(void (^)(NSArray<YDConversation *> *))complete;

- (void)addConversationByMessage:(YDChatMessage *)message;

/**
 *  新的会话
 */
- (BOOL)addConversationByModel:(YDConversation *)conversation;

/**
 *  更新会话状态（已读）
 */
- (BOOL)updateConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid;

/**
 *  所有未读消息数
 */
- (NSInteger)allUnreadMessageByUid:(NSNumber *)uid;

/**
 *  删除一条消息
 */
- (BOOL)deleteConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid;

//删除所有信息
- (void)deleteAllConversations:(NSNumber *)uid;

@end

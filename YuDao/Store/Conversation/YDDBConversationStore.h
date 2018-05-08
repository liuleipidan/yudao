//
//  YDDBConversationStore.h
//  YuDao
//
//  Created by 汪杰 on 16/11/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDConversation.h"

@interface YDDBConversationStore : YDDBBaseStore

/**
 *  新的会话（未读）
 */
- (BOOL)addConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid type:(NSInteger)type date:(NSDate *)date;

/**
 *  新的会话
 */
- (BOOL)addConversationByModel:(YDConversation *)conversation;

/**
 *  更新会话状态（已读）
 */
- (BOOL)updateConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid;

/**
 *  查询所有会话
 */
- (NSArray *)conversationsByUid:(NSNumber *)uid;

/**
 *  单个聊天未读消息数
 */
- (NSInteger)unreadMessageByUid:(NSNumber *)uid fid:(NSNumber *)fid;

/**
 *  所有未读消息数
 */
- (NSInteger)allUnreadMessageByUid:(NSNumber *)uid;

/**
 *  获取一条会话
 */
- (YDConversation *)getOneConversationWithUid:(NSNumber *)uid fid:(NSNumber *)fid;

/**
 *  删除单条会话
 */
- (BOOL)deleteConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid;

/**
 *  删除用户的所有会话
 */
- (BOOL)deleteConversationsByUid:(NSNumber *)uid;

@end

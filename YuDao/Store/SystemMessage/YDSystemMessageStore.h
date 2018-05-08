//
//  YDSystemMessageStore.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDSystemMessage.h"

@interface YDSystemMessageStore : YDDBBaseStore

/**
 插入系统消息
 */
- (BOOL)insertSystemMessage:(YDSystemMessage *)message;

/**
 获取系统消息
 */
- (void)messagesByCount:(NSInteger)count
               complete:(void (^)(NSArray *data, BOOL hasMore))complete;

/**
 统计未读系统消息
 */
- (NSUInteger)countUnreadSystemMessage;

/**
 刷新系统消息已读
 */
- (BOOL)updateSystemMessageToRead;

/**
 最新一条系统消息
 */
- (YDSystemMessage *)newestSystemtMessage;

/**
 删除一条系统消息
 */
- (BOOL)deleteSystemMessageByMsgid:(NSNumber *)msgid;

/**
 删除所有系统消息
 */
- (BOOL)deleteAllSystemMessages;

@end

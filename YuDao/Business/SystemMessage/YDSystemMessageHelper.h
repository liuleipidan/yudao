//
//  YDSystemMessageHelper.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDSystemMessageStore.h"
#import "YDSystemMessageDelegate.h"
#import "GCDMulticastDelegate.h"

@interface YDSystemMessageHelper : NSObject

//多播代理
@property (nonatomic, strong) GCDMulticastDelegate<YDSystemMessageDelegate> *delegate;

//未读系统消息数量
@property (nonatomic, assign, readonly) NSUInteger unreadSysCount;

+ (YDSystemMessageHelper *)sharedInstance;

- (void)requestSystemMessagesCompletion:(void (^)(NSArray *data))completion;

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

/**
 添加代理
 */
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 移除代理
 */
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

@end

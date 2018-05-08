//
//  YDChatHelper.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDChatMessageStore.h"
#import "YDDBConversationStore.h"

#import "YDChatMessage.h"
#import "YDTextChatMeesage.h"
#import "YDImageChatMessage.h"
#import "YDVideoChatMessage.h"
#import "YDVoiceChatMessage.h"
#import "GCDMulticastDelegate.h"
#import "YDChatHelperDelegate.h"

@interface YDChatHelper : NSObject

//多播代理
@property (nonatomic, strong) GCDMulticastDelegate<YDChatHelperDelegate> *delegate;

/**
 当前用户id
 */
@property (nonatomic, strong, readonly) NSNumber *userId;

/**
 聊天记录操作类
 */
@property (nonatomic, strong) YDChatMessageStore *messageStore;

/**
 消息列表操作类
 */
@property (nonatomic, strong) YDDBConversationStore *convStrore;

+ (YDChatHelper *)sharedInstance;

/**
 添加代理
 */
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 移除代理
 */
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

//****************  数据库操作  *****************
/**
 插入一条消息
 */
- (void)addMessage:(YDChatMessage *)message;

/**
 删除一个好友的聊天记录
 */
- (BOOL)deleteChatMessagesByUid:(NSNumber *)uid fid:(NSNumber *)fid;

/**
 删除一个条聊天信息
 */
- (BOOL)deleteOneMessageByMsgId:(NSString *)msgId
                            uid:(NSNumber *)uid
                            fid:(NSNumber *)fid;

/**
 获取一条消息
 */
- (YDChatMessage *)getOneMessageByMsgId:(NSString *)msgId
                                    uid:(NSNumber *)uid
                                    fid:(NSString *)fid;
/**
 获取对应好友最后一条消息
 */
- (YDChatMessage *)getLastMessageByUid:(NSNumber *)uid
                                   fid:(NSNumber *)fid;

/**
 发送消息
 */
- (void)sendMessage:(YDChatMessage *)message;

/**
 接收到消息
 */
- (void)receivedMessage:(YDChatMessage *)message;

/**
 修改消息的发送状态
 */
- (BOOL)updateMessageSendStatus:(YDMessageSendState )status
                      messageId:(NSString *)msgId
                         userId:(NSNumber *)userId;
/**
 修改消息的读取状态
 */
- (BOOL)updateMessageReadStatus:(YDMessageReadState )status
                      messageId:(NSString *)msgId
                         userId:(NSNumber *)userId;

@end

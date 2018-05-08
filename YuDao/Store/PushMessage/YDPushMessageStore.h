//
//  YDPushMessageStore.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDPushMessage.h"
#import "YDPushMessageSQL.h"

@interface YDPushMessageStore : YDDBBaseStore

/**
 创建系统消息表
 */
- (BOOL)createSystemMessageTable;

/**
 创建好友请求表
 */
- (BOOL)createFriendRequestTable;

/**
 插入推送消息

 @param message 消息
 @return 插入成功与否
 */
- (BOOL)addSystemMessage:(YDPushMessage *)message;

/**
 插入好友请求
 
 @param message 消息
 @return 插入成功与否
 */
- (BOOL)addFriendRequestMessage:(YDPushMessage *)message;

/**
 删除一条消息

 @param msgid 消息id
 @return 成功与否
 */
- (BOOL)deleteOnePushMessageByTableName:(NSString *)tableName
                                  msgid:(NSNumber *)msgid;

/**
 获取好友请求消息

 @param userid 当前用户id
 @param count 数量
 @param complete 回调
 */
- (void)getFriendRequestMessageByUserid:(NSNumber *)userid
                                  count:(NSUInteger )count
                               complete:(void (^)(NSArray *data, BOOL hasMore))complete;
/**
 获取系统消息
 
 @param userid 当前用户id
 @param count 数量
 @param complete 回调
 */
- (void)getSystemMessageByUserid:(NSNumber *)userid
                           count:(NSUInteger )count
                        complete:(void (^)(NSArray *data, BOOL hasMore))complete;

/**
 最新一条系统消息

 @param userid 当前用户id
 @return 消息
 */
- (YDPushMessage *)lastPushMessageByUserid:(NSNumber *)userid;

/**
 删除系统消息

 @param userid 用户id
 @return 成功与否
 */
- (BOOL)deleteSystemMessageByUserid:(NSNumber *)userid;

/**
 通过名字搜索好友请求

 @param userid 当前用户id
 @param senderName 搜索名
 @param complete 回调
 */
- (void)searchFriendRequestMessageByUserid:(NSNumber *)userid
                                senderName:(NSString *)senderName
                                  complete:(void (^)(NSArray *data))complete;

/**
 统计系统消息数量
 
 @param userid 当前用户id
 @return 数量
 */
- (NSUInteger)countSystemMessageByUserid:(NSNumber *)userid;

/**
 统计好友请求数量

 @param userid 当前用户id
 @return 数量
 */
- (NSUInteger)countFriendRequestMessageByUserid:(NSNumber *)userid;

/**
 刷新好友请求到已读

 @param userid 当前用户id
 @return 成功与否
 */
- (BOOL)updateFriendRequestMessageToReadByUserid:(NSNumber *)userid;

/**
 刷新系统消息到已读
 
 @param userid 当前用户id
 @return 成功与否
 */
- (BOOL)updateSystemMessageToReadByUserid:(NSNumber *)userid;


/**
 刷新好友请求到已接受

 @param userid 当前用户id
 @param senderid 发送者id
 @return 成功与否
 */
- (BOOL)updateFriendRequestMessageToAccptedByUserid:(NSNumber *)userid
                                           senderid:(NSNumber *)senderid;

- (BOOL)deleteRepeatFriendRequestMessageByUserid:(NSNumber *)userid;

@end

//
//  YDDBSendFriendRequestStore.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDDBSendFriendRequestStore : NSObject

/**
 插入申请好友请求

 @param senderID 发送方id
 @param receiverID 接收方id
 */
+ (void)insertSenderFriendRequestSenderID:(NSNumber *)senderID
                               receiverID:(NSNumber *)receiverID;

/**
 不存在此请求，返回NO
 存在此请求，时间当前时间相差大于三天，删除此记录，返回NO；小于三天，返回YES

 @param senderID 发送方id
 @param receiverID 接收方id
 @return yes->存在，no->不存在
 */
+ (BOOL)checkSenderFriendRequsetExistOrNeedDeleteBySenderID:(NSNumber *)senderID
                                                 receiverID:(NSNumber *)receiverID;

/**
 删除此条申请

 @param senderID 发送方id
 @param receiverID 接收方id
 */
+ (void)deleteSenderFriendRequestSenderID:(NSNumber *)senderID
                                 receiverID:(NSNumber *)receiverID;

@end

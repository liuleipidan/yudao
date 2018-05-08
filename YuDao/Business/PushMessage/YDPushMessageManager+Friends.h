//
//  YDPushMessageManager+Friends.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPushMessageManager.h"

@interface YDPushMessageManager (Friends)

/**
 获取好友请求
 */
- (void)getFriendRequestMessageByUserid:(NSNumber *)userid
                                  count:(NSUInteger )count
                               complete:(void (^)(NSArray *data, BOOL hasMore))complete;
/**
 删除好友请求
 */
- (void)deleteFriendRequestByMsgid:(NSNumber *)msgid;

/**
 统计未读好友请求
 */
- (NSUInteger)countFriendRequestMessageByUserid:(NSNumber *)userid;

/**
 刷新已读好友请求
 */
- (void)updateFriendRequestMessageToReadByUserid:(NSNumber *)userid;

/**
 刷新已接受好友请求
 */
- (void)updateFriendRequestMessageToAccptedByUserid:(NSNumber *)userid
                                           senderid:(NSNumber *)senderid;
/**
 通过发送方名字搜索好友请求
 */
- (void)searchFriendRequestMessageByUserid:(NSNumber *)userid
                                senderName:(NSString *)senderName
                                  complete:(void (^)(NSArray *data))complete;

@end

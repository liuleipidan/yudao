//
//  YDPushMessageManager+Friends.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPushMessageManager+Friends.h"

@implementation YDPushMessageManager (Friends)

- (void)getFriendRequestMessageByUserid:(NSNumber *)userid
                                  count:(NSUInteger )count
                               complete:(void (^)(NSArray *data, BOOL hasMore))complete{
    [self.frStore getFriendRequestMessageByUserid:userid count:count complete:complete];
}

- (void)deleteFriendRequestByMsgid:(NSNumber *)msgid{
    if ([self.frStore deleteOnePushMessageByTableName:FRIEND_REQUEST_TABLE_NAME msgid:msgid]) {
        YDLog(@"删除一条好友请求成功");
    }else{
        YDLog(@"删除一条好友请求失败");
    }
}

- (NSUInteger)countFriendRequestMessageByUserid:(NSNumber *)userid{
    return [self.frStore countFriendRequestMessageByUserid:userid];
}

- (void)updateFriendRequestMessageToReadByUserid:(NSNumber *)userid{
    if (![self.frStore updateFriendRequestMessageToReadByUserid:userid]) {
        YDLog(@"刷新好友请求失败");
    }
    [self.delegate unreadFirendRequestCountDidChange];
}

- (void)searchFriendRequestMessageByUserid:(NSNumber *)userid
                                senderName:(NSString *)senderName
                                  complete:(void (^)(NSArray *data))complete{
    [self.frStore searchFriendRequestMessageByUserid:userid senderName:senderName complete:complete];
}


- (void)updateFriendRequestMessageToAccptedByUserid:(NSNumber *)userid
                                           senderid:(NSNumber *)senderid{
    if ([self.frStore updateFriendRequestMessageToAccptedByUserid:userid senderid:senderid]) {
        YDLog(@"刷新好友请求已添加成功");
    }else{
        YDLog(@"刷新好友请求已添加失败");
    }
}

@end

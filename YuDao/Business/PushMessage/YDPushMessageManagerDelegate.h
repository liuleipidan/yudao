//
//  YDPushMessageManagerDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDPushMessage;
@protocol YDPushMessageManagerDelegate <NSObject>

@optional


/**
 收到好友请求
 */
- (void)receivedNewFriendRequest;

/**
 未读好友请求数量改变
 */
- (void)unreadFirendRequestCountDidChange;

/**
 收到首页消息
 */
- (void)receivedHomePageMessages:(NSArray<YDPushMessage *> *)messages;

@end

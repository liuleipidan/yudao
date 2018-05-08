//
//  YDPushMessageManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDPushMessageStore.h"
#import "YDPushMessageManagerDelegate.h"
#import "GCDMulticastDelegate.h"

@interface YDPushMessageManager : NSObject

//多播代理
@property (nonatomic, strong) GCDMulticastDelegate<YDPushMessageManagerDelegate> *delegate;

//好友请求数据库
@property (nonatomic, strong) YDPushMessageStore *frStore;

//未读好友请求数量
@property (nonatomic, assign) NSUInteger frCount;

+ (YDPushMessageManager *)sharePushMessageManager;

/**
 请求所有推送消息
 */
- (void)requestPushMessagesByCurrentUserid:(NSNumber *)userid;

/**
 插入消息到数据库
 */
- (void)addPushMessages:(NSArray<YDPushMessage *> *)messages;

/**
 添加代理
 */
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 移除代理
 */
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

@end

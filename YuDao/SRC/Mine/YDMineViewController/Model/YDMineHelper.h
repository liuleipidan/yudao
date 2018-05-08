//
//  YDMineHelper.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDVisitorsModel.h"
#import "YDMineMenuItem.h"

@interface YDMineHelper : NSObject

/**
 UI
 */
@property (nonatomic, strong) NSMutableArray *mineMenuData;

/**
 访客
 */
@property (nonatomic, strong) NSMutableArray *visitors;

/**
 动态消息未读数量
 */
@property (nonatomic,assign) NSUInteger dyMsgUnreadCount;

/**
 未读数量发送改变回调
 */
@property (nonatomic,copy) void (^unreadCountChanged) (void);

+ (YDMineHelper *)sharedInstance;

/**
 计算未读消息(系统消息+聊天消息)数量和好友请求消息
 */
- (void)recountUnreadMessages;

/**
 请求最近访客
 */
- (void)requestRecentVistors:(void (^)(void))completion;

/**
 请求动态消息数量
 */
- (void)requestDynamicMessagesCount;

@end


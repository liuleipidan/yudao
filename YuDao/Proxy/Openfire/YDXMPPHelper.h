//
//  YDXMPPHelper.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "YDChatMessage.h"

#pragma mark - Room - 聊天室
#import <XMPPRoom.h>
#import <XMPPRoomHybridStorage.h>
#import <XMPPRoomMemoryStorage.h>
#import <XMPPRoomCoreDataStorage.h>

#pragma mark - 服务器域名和端口
#define kHostName kEnvironmentalKey
#define kHostPort 5222

@interface YDXMPPHelper : NSObject<XMPPStreamDelegate>

@property (nonatomic, strong) XMPPStream *stream;

#pragma mark - Connect State
@property (nonatomic, assign, readonly) BOOL isConnected;

+ (instancetype)sharedInstance;

/**
 发送消息

 @param message 消息对象
 */
- (void)sendChatMessage:(YDChatMessage *)message;

/**
 登录xmpp

 @param userId 用户id
 @param password 用户密码
 */
- (void)loginXmppWithUserId:(NSNumber *)userId password:(NSString *)password;

/**
 退出xmpp
 */
- (void)logoutXmpp;



@end

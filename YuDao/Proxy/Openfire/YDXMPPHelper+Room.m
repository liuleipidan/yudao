//
//  YDXMPPHelper+Room.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDXMPPHelper+Room.h"

//聊天室子域名
static NSString *const kXMPP_SUBDOMAIN = @"conference";

@implementation YDXMPPHelper (Room)

- (void)joinRoom:(NSString *)roomName usingNickname:(NSString *)nickName{
    NSString *roomId = [NSString stringWithFormat:@"%@@%@.%@",roomName,kXMPP_SUBDOMAIN,kHostName];
    
    XMPPJID *roomJid = [XMPPJID jidWithString:roomId];
    //XMPPRoomHybridStorage *xmppRoomStorage = [XMPPRoomHybridStorage sharedInstance];
    
    XMPPRoomCoreDataStorage *roomStorage = [XMPPRoomCoreDataStorage sharedInstance];
    
    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomStorage jid:roomJid dispatchQueue:dispatch_get_main_queue()];
    [xmppRoom activate:self.stream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:nickName history:nil password:nil];
    
}

- (void)configNewRoom:(XMPPRoom *)xmppRoom
{
    NSXMLElement *x = [NSXMLElement elementWithName:@"x"xmlns:@"jabber:x:data"];
    NSXMLElement *p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_persistentroom"];//永久房间
    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_maxusers"];//最大用户
    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"10000"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_changesubject"];//允许改变主题
    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_publicroom"];//公共房间
    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"0"]];
    [x addChild:p];
    
    
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var"stringValue:@"muc#roomconfig_allowinvites"];//允许邀请
    [p addChild:[NSXMLElement elementWithName:@"value"stringValue:@"1"]];
    [x addChild:p];
    
    [xmppRoom configureRoomUsingOptions:x];
}

#pragma mark -  XMPPRoomDelegate
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    YDLog(@"房间创建成功");
}
#pragma mark - 加入房间成功
- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    YDLog(@"加入房间成功");
    
    //房间配置
    //[self configNewRoom:sender];
    //拉取房间配置
    [sender fetchConfigurationForm];
    //拉取禁止成员
    [sender fetchBanList];
    //拉取普通成员
    [sender fetchMembersList];
    //拉取主持者成员
    [sender fetchModeratorsList];
}


- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    YDLog(@"configForm:%@",configForm);
}

/**
 获取被禁用户列表成功

 @param sender 聊天室
 @param items 被禁用户列表
 */
- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    YDLog(@"%s",__func__);
}


/**
 获取聊天室成员列表成功

 @param sender 聊天室
 @param items 成员列表
 */
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    YDLog(@"收到聊天室成员列表 %s",__func__);
    
    for (id member in items) {
        YDLog(@"member = %@",member);
    }
    
}

/**
 获取主持人列表成功
 
 @param sender 聊天室
 @param items 主持人
 */
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    YDLog(@"%s",__func__);
}

/**
 收到聊天室消息，这里会把前面的所有的历史记录一起拉下来，需要看这个代理是否要用

 @param sender 发送聊天室
 @param message 消息
 @param occupantJID 发送者
 */
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{
    YDLog(@"message = %@",message);
    YDLog(@"occupantJID = %@",occupantJID);
    YDLog(@"body = %@",message.body);
    
}


/**
 有人加入聊天室

 @param sender 聊天室
 @param occupantJID 加入者
 @param presence 加入者的状态
 */
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    YDLog(@"有人加入房间 occupantJID = %@",occupantJID);
    YDLog(@"presence = %@",presence);
    
}

/**
 有人离开聊天室

 @param sender 聊天室
 @param occupantJID 离开者
 @param presence 离开者的状态
 */
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    YDLog(@"有人离开房间 occupantJID = %@",occupantJID);
    YDLog(@"presence = %@",presence);
}

/**
 未知功能代理
 */
- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    YDLog(@"occupantDidUpdate occupantJID = %@",occupantJID);
    YDLog(@"presence = %@",presence);
}

/**
 获取主持人列表失败

 @param sender 聊天室
 @param iqError 错误信息
 */
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    YDLog(@"%s iqError = %@",__func__,iqError);
}

/**
 获取成员列表失败

 @param sender 聊天室
 @param iqError 错误信息
 */
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    YDLog(@"%s iqError = %@",__func__,iqError);
}

/**
 获取主持人列表失败

 @param sender 聊天室
 @param iqError 错误信息
 */
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
    YDLog(@"%s iqError = %@",__func__,iqError);
}


@end

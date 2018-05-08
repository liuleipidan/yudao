//
//  YDXMPPHelper.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDXMPPHelper.h"
#import "YDXMPPHelper+Room.h"

@interface YDXMPPHelper()

/**
 心跳包
 */
@property (nonatomic, strong) XMPPAutoPing *autoPing;

/**
 重连
 */
@property (nonatomic, strong) XMPPReconnect *reconnect;

/**
 电子名片
 */
@property (nonatomic, strong) XMPPvCardTempModule *vCardModule;

/**
 当前用户id
 */
@property (nonatomic, strong) NSNumber *userId;

/**
 密码
 */
@property (nonatomic, copy  ) NSString *password;

/**
 在线好友id数组
 */
@property (nonatomic, strong) NSMutableArray<NSString *> *availableFriendsUidArray;

@end

static YDXMPPHelper *xmppHelper = nil;

@implementation YDXMPPHelper

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmppHelper = [[YDXMPPHelper alloc] init];
    });
    return xmppHelper;
}

- (instancetype)init{
    if (self = [super init]) {
        _availableFriendsUidArray = [NSMutableArray array];
    }
    return self;
}
- (XMPPStream *)stream{
    if (_stream == nil) {
#pragma mark - 初始化流
        _stream = [[XMPPStream alloc] init];
        [_stream setHostName:kHostName];
        [_stream setHostPort:kHostPort];
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
#pragma mark - 心跳机制
        _autoPing = [[XMPPAutoPing alloc] init];
        [_autoPing setPingInterval:1000];   //心跳发送间隔时间
        [_autoPing setRespondsToQueries:YES];//对方是用户是否响应
        [_autoPing activate:_stream];
        
#pragma mark - 自动重连
        _reconnect = [[XMPPReconnect alloc] init];
        [_reconnect setAutoReconnect:YES];
        [_reconnect activate:_stream];
        
#pragma mark - 电子名片
        XMPPvCardCoreDataStorage *vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
        _vCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:vCardStorage];
        [_vCardModule activate:_stream];
    }
    return _stream;
}
#pragma mark ================ Methods ==========================
- (void)sendChatMessage:(YDChatMessage *)message{
    XMPPJID *toJid = [XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",message.fid] domain:kHostName resource:nil];
    XMPPMessage *xpMessage = [XMPPMessage messageWithType:@"chat" to:toJid elementID:message.msgId];
    NSString *subject = [NSString stringWithFormat:@"%ld,%@",message.messageType,[message.date timeStampFromDate]];
    [xpMessage addSubject:subject];
    
    //为了兼容老版本
    if (message.messageType == YDMessageTypeText) {
        [xpMessage addBody:[message.content objectForKey:@"text"]];
    }else{
       [xpMessage addBody:[message.content mj_JSONString]];
    }
    [self.stream sendElement:xpMessage];
    
}
- (void)loginXmppWithUserId:(NSNumber *)userId password:(NSString *)password{
    
    _password = password;
    _userId = userId;
    XMPPJID *myJid = [XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",userId] domain:kHostName resource:nil];
    [self.stream setMyJID:myJid];
    
    //开始连接
    if ([self.stream connectWithTimeout:XMPPStreamTimeoutNone error:nil]) {
        YDLog(@"开始连接流");
    }
}
- (void)logoutXmpp{
    [self.stream disconnect];
    [self.stream removeDelegate:self];
    self.reconnect.autoReconnect = NO;
    [self.reconnect deactivate];
    [self.autoPing deactivate];
    self.stream = nil;
    self.userId = nil;
    self.password = nil;
}

//上线
- (void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence];
    //状态描述，自定义（类型QQ签名）
    //[presence addChild:[DDXMLNode elementWithName:@"status" stringValue:@"空闲中..."]];
    //上线状态：dnd->正忙,xa->离开,away->离开，chat->空闲
    //[presence addChild:[DDXMLNode elementWithName:@"show" stringValue:@"chat"]];
    //发到服务器
    [self.stream sendElement:presence];
}

#pragma mark ================ XMPPStreamDelegate ==========================
#pragma mark - 连接
//socket成功连接
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    YDLog();
}
//流成功连接
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    if (![_stream authenticateWithPassword:_password error:nil]) {
        YDLog(@"发送验证密码失败");
    }
}
//连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    YDLog();
}
//断开链接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    YDLog(@"error = %@",error.localizedDescription);
}
#pragma mark - 验证
//验证（登录）成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [self goOnline];
    
#pragma mark - 这里加入聊天室
    
    //[self joinRoom:[NSString stringWithFormat:@"%@_%@",@7,@621] usingNickname:[NSString stringWithFormat:@"%@",YDUser_id]];
    
    YDLog(@"openfire 登录成功");
}
//验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    YDLog(@"openfire 登录失败");
}
#pragma mark - 好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSString *fUid = presence.from.user;
    //YDLog(@"fUid = %@,presence.type = %@",presence.type,fUid);
    //在线加入数组
    if ([presence.type isEqualToString:@"available"]) {
        if (![self.availableFriendsUidArray containsObject:fUid]) {
            [self.availableFriendsUidArray addObject:fUid];
        }
    }
    else{//不在线剔除
        if ([self.availableFriendsUidArray containsObject:fUid]) {
            [self.availableFriendsUidArray removeObject:fUid];
        }
    }
}
#pragma mark  ======= 消息 =======
#pragma mark - 接收
//接受到一个iq
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    YDLog(@"receiveIQ:%@",iq);
    return YES;
}
//接受到消息，消息可能为空
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    if (message.body) {
        NSString *subject = [message subject];
        NSArray *strArr = [subject componentsSeparatedByString:@","];
        if (strArr.count == 2) {
            NSString *type = strArr.firstObject;
            NSString *time = strArr.lastObject;
            YDChatMessage *chatMessage = [YDChatMessage createChatMessageByType:type.integerValue];
            chatMessage.messageType = type.integerValue;
            chatMessage.uid = [YDUserDefault defaultUser].user.ub_id;
            chatMessage.fid = @(message.from.user.integerValue);
            chatMessage.date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
            NSString *content = message.body;
            if (chatMessage.messageType == YDMessageTypeText) {
                [chatMessage.content setObject:content forKey:@"text"];
            }else{
                chatMessage.content = [NSMutableDictionary dictionaryWithDictionary:[content mj_JSONObject]];
            }
            chatMessage.ownerType = YDMessageOwnerTypeFriend;
            chatMessage.sendState = YDMessageSendSuccess;
            chatMessage.readState = YDMessageUnRead;
            [[YDChatHelper sharedInstance] receivedMessage:chatMessage];
        }
    }else{
        YDLog(@"正在输入...");
    }
}
#pragma mark - 发送
//成功发送一个iq
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
    //YDLog(@"sendIQ:%@",iq);
}
//消息发送成功
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    YDLog(@"消息发送成功");
    //修改消息发送状态
    BOOL ok = [[YDChatHelper sharedInstance] updateMessageSendStatus:YDMessageSendSuccess messageId:message.elementID userId:YDUser_id];
    if (ok) {
        YDLog(@"修改发送状态成功：YDMessageSendSuccess");
        //在此处判断对方不在线发送推送
        if (![self.availableFriendsUidArray containsObject:message.to.user]) {
            [YDNetworking requestSenderChatMessageNotificationReceiverId:message.to.user messageId:message.elementID success:^{
                
            } failure:^{
                
            }];
        }
        //通知正在聊天的界面
        [[YDChatHelper sharedInstance].delegate chatMessageSendSuccess:message.elementID];
    }
}
//消息发送失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    //修改消息发送状态
    BOOL ok = [[YDChatHelper sharedInstance] updateMessageSendStatus:YDMessageSendFail messageId:message.elementID userId:YDUser_id];
    if (ok) {
        YDLog(@"修改发送状态成功：YDMessageSendFail");
        //通知正在聊天的界面
        [[YDChatHelper sharedInstance].delegate chatMessageSendFail:message.elementID];
    }
}

#pragma mark - Getter
- (BOOL)isConnected{
    return self.stream.isConnected;
}

@end

//
//  YDChatHelper.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatHelper.h"
#import "YDChatHelper+ChatRecord.h"
#import "YDChatHelper+ConversationRecord.h"
#import "VoiceConverter.h"

@interface YDChatHelper()


@end

static YDChatHelper *chatHelper = nil;
@implementation YDChatHelper

+ (YDChatHelper *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatHelper = [[YDChatHelper alloc] init];
    });
    return chatHelper;
}

- (instancetype)init{
    if (self = [super init]) {
        _delegate = (GCDMulticastDelegate <YDChatHelperDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    return self;
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [_delegate addDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [_delegate removeDelegate:delegate delegateQueue:delegateQueue];
}

- (void)addMessage:(YDChatMessage *)message{
    if ([self.messageStore addChatMessage:message]) {
        [self addConversationByMessage:message];
        if (message.messageType == YDMessageTypeVoice) {
            //[self downloadVoiceDataWith:(YDVoiceChatMessage *)message];
        }
        if (message.ownerType == YDMessageOwnerTypeFriend) {
            [_delegate receiveChatMessage:message];
        }
        [_delegate unreadChatMessageCountHadChanged];
    }else{
        YDLog(@"插入消息失败");
    }
}

- (void)sendMessage:(YDChatMessage *)message{
    //存入数据库
    if ([self.messageStore addChatMessage:message]) {
        [self addConversationByMessage:message];
        YDLog(@"发送：插入消息成功");
    }else{
        YDLog(@"发送：插入消息失败");
    }
    
    [[YDXMPPHelper sharedInstance] sendChatMessage:message];
}

- (void)receivedMessage:(YDChatMessage *)message{
    if ([self.messageStore addChatMessage:message]) {
        //插入消息列表
        [self addConversationByMessage:message];
        //语言消息需下载
        if (message.messageType == YDMessageTypeVoice) {
            [self downloadVoiceDataWith:(YDVoiceChatMessage *)message];
        }
        
        //发送收到消息通知
        [_delegate receiveChatMessage:message];
        [_delegate unreadChatMessageCountHadChanged];
    }
}

- (BOOL)deleteChatMessagesByUid:(NSNumber *)uid fid:(NSNumber *)fid{
    return [self.messageStore deleteChatMessagesByUid:uid fid:fid];
}

- (BOOL)deleteOneMessageByMsgId:(NSString *)msgId
                            uid:(NSNumber *)uid
                            fid:(NSNumber *)fid{
    return [self.messageStore deleteOneMessageByMsgId:msgId uid:uid fid:fid];
}

- (YDChatMessage *)getOneMessageByMsgId:(NSString *)msgId
                                    uid:(NSNumber *)uid
                                    fid:(NSString *)fid{
    return [self.messageStore getOneMessageByMsgId:msgId uid:uid fid:fid];
}

- (YDChatMessage *)getLastMessageByUid:(NSNumber *)uid
                                   fid:(NSNumber *)fid{
    return [self.messageStore getLastMessageByUid:uid fid:fid];
}

- (BOOL)updateMessageSendStatus:(YDMessageSendState )status
                      messageId:(NSString *)msgId
                         userId:(NSNumber *)userId{
    return [self.messageStore updateMessageSendStatus:status messageId:msgId userId:userId];
}

- (BOOL)updateMessageReadStatus:(YDMessageReadState )status
                      messageId:(NSString *)msgId
                         userId:(NSNumber *)userId{
    return [self.messageStore updateMessageReadStatus:status messageId:msgId userId:userId];
}

#pragma mark - Private Methods
/**
 下载语言数据
 1.数据为amr格式，需转成wav
 2.转换完成后删除掉amr文件
 */
- (void)downloadVoiceDataWith:(YDVoiceChatMessage *)message{
    
    YDWeakSelf(self);
    [YDNetworking downloadVoiceFileWithURL:message.url success:^(NSString *filePath) {
        NSString *fileName = [NSString stringWithFormat:@"%.0lf.wav", [NSDate date].timeIntervalSince1970 * 1000];
        NSString *path = [NSFileManager pathUserChatVoice:fileName];
        //amr->wav
        int ok = [VoiceConverter ConvertAmrToWav:filePath wavSavePath:path];
        if (ok) {
            message.recFileName = fileName;
            [weakself.messageStore addChatMessage:message];
            //移除原amr文件
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    } failure:^{
        
    }];
}


#pragma mark - Getter 
- (NSNumber *)userId{
    return [YDUserDefault defaultUser].user.ub_id;
}

- (YDChatMessageStore *)messageStore{
    if (!_messageStore) {
        _messageStore = [[YDChatMessageStore alloc] init];
    }
    return _messageStore;
}

- (YDDBConversationStore *)convStrore{
    if (!_convStrore) {
        _convStrore = [[YDDBConversationStore alloc] init];
    }
    return _convStrore;
}


@end

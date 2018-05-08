//
//  YDPushMessageManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPushMessageManager.h"
#import "YDPushMessageManager+Friends.h"
#import "YDPushMessageManager+HomePage.h"
#import "YDDBSendFriendRequestStore.h"
#import "YDPushMessageManager+Friends.h"
#import "YDChatHelper+ConversationRecord.h"

@interface YDPushMessageManager()


@end

static YDPushMessageManager *pushMessageManager = nil;
@implementation YDPushMessageManager

+ (YDPushMessageManager *)sharePushMessageManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pushMessageManager = [[YDPushMessageManager alloc] init];
    });
    return pushMessageManager;
}

- (instancetype)init{
    if (self = [super init]) {
        
        _frStore = [[YDPushMessageStore alloc] init];
        [_frStore createFriendRequestTable];
        
        _delegate = (GCDMulticastDelegate <YDPushMessageManagerDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    return self;
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [_delegate addDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [_delegate removeDelegate:delegate delegateQueue:delegateQueue];
}

- (void)requestPushMessagesByCurrentUserid:(NSNumber *)userid{
    YDWeakSelf(self);
    NSDictionary *para = @{
                           @"access_token":YDAccess_token
                           };
    [YDNetworking GET:kPushMessageURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200] && data) {
            NSArray<YDPushMessage *> *messages = [YDPushMessage mj_objectArrayWithKeyValuesArray:data];
            [weakself addPushMessages:messages];
        }
        else if (code.integerValue == YDServerMessageTypeUserInvalid){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController YD_OK_AlertController:[YDRootViewController sharedRootViewController] title:@"用户已失效\n或在其他设备上登录" clickBlock:^{
                    //移除用户信息
                    [[YDUserDefault defaultUser] removeUser];
                    UIViewController *currentVC = [UIViewController yd_getTheCurrentViewController];
                    //如果当前界面非登录界面
                    if (currentVC == nil || ![currentVC isKindOfClass:[YDLoginViewController class]]) {
                        if (![currentVC isKindOfClass:[YDLoginViewController class]]) {
                            [[YDRootViewController sharedRootViewController] presentViewController:[YDLoginViewController new] animated:YES completion:^{
                                [[YDRootViewController sharedRootViewController] releaseNavigationControllerAndShowViewControllerWithIndex:0];
                            }];
                        }
                    }
                }];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)addPushMessages:(NSArray<YDPushMessage *> *)messages{
    if (!messages || messages.count == 0) {
        return;
    }
    __block BOOL hasFriendRequest = NO;
    [messages enumerateObjectsUsingBlock:^(YDPushMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userid = [YDUserDefault defaultUser].user.ub_id;
        obj.readState = YDMessageUnRead;
        obj.frStatus = YDFriendRequestStatusNormal;
        
        if ([obj.msgSubtype isEqual:@1001]) {//好友请求
            if ([self.frStore addFriendRequestMessage:obj]) {
                YDLog(@"好友请求插入成功");
            }
            hasFriendRequest = YES;
        }
        else{//非好友请求
            if ([obj.msgSubtype isEqual:@1002]) {//对方同意好友请求
                [YDDBSendFriendRequestStore deleteSenderFriendRequestSenderID:YDUser_id receiverID:obj.senderid];
                
                [[YDPushMessageManager sharePushMessageManager] updateFriendRequestMessageToAccptedByUserid:YDUser_id senderid:obj.senderid];
            }
            else if ([obj.msgSubtype isEqual:@1003]){//被对方删除
                //1.删除好友申请
                [YDDBSendFriendRequestStore deleteSenderFriendRequestSenderID:YDUser_id receiverID:obj.senderid];
                //2.删除数据库里对应好友
                if ([[YDFriendHelper sharedFriendHelper] deleteFriendByFid:obj.senderid]) {
                    YDLog(@"删除数据库好友成功");
                }
                //3.删除好友消息记录
                if ([[YDChatHelper sharedInstance] deleteChatMessagesByUid:YDUser_id fid:obj.senderid]) {
                    YDLog(@"删除好友聊天记录成功");
                }
                //4.删除好友消息列表
                if ([[YDChatHelper sharedInstance] deleteConversationByUid:YDUser_id fid:obj.senderid]) {
                    YDLog(@"删除好友消息列表成功");
                }
                
            }
        }
    }];
    if (hasFriendRequest) {
        [_delegate receivedNewFriendRequest];
    }
}

#pragma mark - Getters
- (NSUInteger)frCount{
    return [self.frStore countFriendRequestMessageByUserid:[YDUserDefault defaultUser].user.ub_id];
}

@end

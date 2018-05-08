//
//  YDSystemMessageHelper.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSystemMessageHelper.h"

#define kSystemMessagesURL  [kOriginalURL stringByAppendingString:@"sysmessage"]

@interface YDSystemMessageHelper()

@property (nonatomic, strong) YDSystemMessageStore *store;

@end

static YDSystemMessageHelper *systemMessageHelper = nil;

@implementation YDSystemMessageHelper

+ (YDSystemMessageHelper *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemMessageHelper = [[YDSystemMessageHelper alloc] init];
    });
    return systemMessageHelper;
}

- (id)init{
    if (self = [super init]) {
        _store = [[YDSystemMessageStore alloc] init];
        _delegate = (GCDMulticastDelegate <YDSystemMessageDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    return self;
}

- (void)requestSystemMessagesCompletion:(void (^)(NSArray *data))completion{
    NSDictionary *param = @{
                            @"access_token":YDAccess_token
                            };
    [YDNetworking GET:kSystemMessagesURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200] && data) {
            NSArray *messages = [YDSystemMessage mj_objectArrayWithKeyValuesArray:data];
            [self insertSystemMessages:messages];
            if (completion) {
                completion(messages);
            }
        }
    } failure:^(NSError *error) {
        YDLog(@"系统消息 error = %@",error.localizedDescription);
    }];
}

/**
 获取系统消息
 */
- (void)messagesByCount:(NSInteger)count
               complete:(void (^)(NSArray *data, BOOL hasMore))complete{
    [self.store messagesByCount:count complete:complete];
}

/**
 统计未读系统消息
 */
- (NSUInteger)countUnreadSystemMessage{
    return [self.store countUnreadSystemMessage];
}

/**
 刷新系统消息已读
 */
- (BOOL)updateSystemMessageToRead{
    BOOL ok = [self.store updateSystemMessageToRead];
    if (ok) {
        [_delegate systemMessagesAreRead];
    }
    return ok;
}

/**
 最新一条系统消息
 */
- (YDSystemMessage *)newestSystemtMessage{
    return [self.store newestSystemtMessage];
}

/**
 删除一条系统消息
 */
- (BOOL)deleteSystemMessageByMsgid:(NSNumber *)msgid{
    return [self.store deleteSystemMessageByMsgid:msgid];
}

/**
 删除所有系统消息
 */
- (BOOL)deleteAllSystemMessages{
    return [self.store deleteAllSystemMessages];
}

#pragma mark - Delegate
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [_delegate addDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [_delegate removeDelegate:delegate delegateQueue:delegateQueue];
}

#pragma mark - Private Methods
- (void)insertSystemMessages:(NSArray<YDSystemMessage *> *)messages{
    __block BOOL hasSystemMessage = NO;
    __block BOOL hadFinishTask = NO;
    [messages enumerateObjectsUsingBlock:^(YDSystemMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.msgType isEqual:@1]) {
            hasSystemMessage = YES;
            if (![self.store insertSystemMessage:obj]) {
                YDLog(@"插入系统消息失败");
            }
        }
        //完成任务
        if (obj.msgSubtype.integerValue == YDServerMessageTypeTaskFinished) {
            hadFinishTask = YES;
        }
    }];
    
    if (hasSystemMessage) {
        [_delegate receivedNewSystemMessages];
        [[YDUserDefault defaultUser] refreshUserInformationSuccess:nil failure:nil];
    }
    
    //有任务被完成
    if (hadFinishTask) {
        [_delegate systemMessagesHadFinishTask];
    }
}

#pragma mark - Getter
- (NSUInteger)unreadSysCount{
    return [self.store countUnreadSystemMessage];
}

@end

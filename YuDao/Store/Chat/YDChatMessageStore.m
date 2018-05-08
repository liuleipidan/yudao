//
//  YDChatMessageStore.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatMessageStore.h"
#import "YDDBChatMessageSQL.h"

@implementation YDChatMessageStore

- (instancetype)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].messageQueue;
        if (![self createTable]) {
            
        }
    }
    return self;
}

- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_MESSAGE_TABLE,CHAT_MESSAGE_TABLE_NAME];
    return  [self createTable:CHAT_MESSAGE_TABLE_NAME withSQL:sqlString];
}

- (BOOL)addChatMessage:(YDChatMessage *)message{
    
    if (message == nil || message.msgId == nil || message.uid == nil || message.fid == nil) {
        return NO;
    }
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_CHAT_MESSAGE_TABLE,CHAT_MESSAGE_TABLE_NAME];
    NSArray *para = @[ message.msgId,
                      message.uid,
                       message.fid,
                       YDMessageTimeStamp(message.date),
                       @(message.ownerType),
                       @(message.messageType),
                       [message.content mj_JSONString],
                       @(message.sendState),
                       @(message.readState)];
    return [self excuteSQL:sqlString withArrParameter:para];
}

- (BOOL)deleteChatMessagesByUid:(NSNumber *)uid fid:(NSNumber *)fid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_MESSAGES,CHAT_MESSAGE_TABLE_NAME,uid,fid];
    YDLog(@"删除一个好友的聊天记录 sqlString = %@",sqlString);
    return [self excuteSQL:sqlString];
}

- (BOOL)deleteOneMessageByMsgId:(NSString *)msgId
                            uid:(NSNumber *)uid
                            fid:(NSNumber *)fid{
    //SQL_DELETE_ONE_MESSAGE
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ONE_MESSAGE,CHAT_MESSAGE_TABLE_NAME,msgId,uid,fid];
    YDLog(@"删除一个条聊天记录 sqlString = %@",sqlString);
    return [self excuteSQL:sqlString];
}

- (YDChatMessage *)getOneMessageByMsgId:(NSString *)msgId
                                    uid:(NSNumber *)uid
                                    fid:(NSString *)fid{
    __block YDChatMessage *message = nil;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_ONE_MESSAGE,CHAT_MESSAGE_TABLE_NAME,msgId,uid,fid];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            message = [self y_createMessageByFMResult:rsSet];
        }
        [rsSet close];
    }];
    return message;
}

- (YDChatMessage *)getLastMessageByUid:(NSNumber *)uid
                                   fid:(NSNumber *)fid{
    __block YDChatMessage *message = nil;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_LAST_CHAT_MESSAGE,CHAT_MESSAGE_TABLE_NAME,CHAT_MESSAGE_TABLE_NAME,uid,fid];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            message = [self y_createMessageByFMResult:rsSet];
        }
        [rsSet close];
    }];
    return message;
}


- (void)chatMessageByUserId:(NSNumber *)userId
                        fid:(NSNumber *)fid
                   fromDate:(NSDate *)date
                      count:(NSUInteger )count
                 completion:(void (^)(NSArray *data, BOOL hasMore))completion{
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:
                           SQL_SELECT_CHAT_MESSAGE_PAGE,
                           CHAT_MESSAGE_TABLE_NAME,
                           userId,
                           fid,
                           [NSString stringWithFormat:@"%ld",(long)date.timeIntervalSince1970],
                           (long)(count + 1)];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDChatMessage *message = [self y_createMessageByFMResult:rsSet];
            if (message) {
                [data insertObject:message atIndex:0];
            }
        }
        [rsSet close];
    }];
    BOOL hasMore = NO;
    if (data.count == count + 1) {
        hasMore = YES;
        [data removeObjectAtIndex:0];
    }
    if (completion) {
        completion(data,hasMore);
    }
}

- (NSArray *)chatImagesAndVideosByUserId:(NSNumber *)userId fid:(NSString *)fid{
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CHAT_IMAGES,CHAT_MESSAGE_TABLE_NAME,userId,fid];
    YDLog(@"chatImagesAndVideosByUserId sqlString = %@",sqlString);
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDChatMessage *message = [self y_createMessageByFMResult:rsSet];
            if (message) {
                [data insertObject:message atIndex:0];
            }
        }
        [rsSet close];
    }];
    return data;
}

- (BOOL)updateMessageSendStatus:(YDMessageSendState )status
                      messageId:(NSString *)msgId
                         userId:(NSNumber *)userId{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_MESSAGE_SENDS_STATUS,CHAT_MESSAGE_TABLE_NAME,status,msgId,userId];
    YDLog(@"刷新聊天消息的发送状态sqlString = %@",sqlString);
    return [self excuteSQL:sqlString];
}

- (BOOL)updateMessageReadStatus:(YDMessageReadState )status
                      messageId:(NSString *)msgId
                         userId:(NSNumber *)userId{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_MESSAGE_READ_STATUS,CHAT_MESSAGE_TABLE_NAME,status,msgId,userId];
    YDLog(@"刷新聊天消息的读取状态");
    return [self excuteSQL:sqlString];
}

- (YDChatMessage *)y_createMessageByFMResult:(FMResultSet *)reSet{
    YDMessageType type = [reSet intForColumn:@"msg_type"];
    YDChatMessage *message = [YDChatMessage createChatMessageByType:type];
    message.msgId = [reSet stringForColumn:@"msgid"];
    message.uid = @([reSet intForColumn:@"uid"]);
    message.fid = @([reSet intForColumn:@"fid"]);
    NSString *dateString = [reSet stringForColumn:@"date"];
    message.date = [NSDate dateWithTimeIntervalSince1970:dateString.integerValue];
    message.ownerType = [reSet intForColumn:@"own_type"];
    NSString *content = [reSet stringForColumn:@"content"];
    message.content = [NSMutableDictionary dictionaryWithDictionary:[content mj_JSONObject]];
    message.sendState = [reSet intForColumn:@"send_status"];
    message.readState = [reSet intForColumn:@"read_status"];
    return message;
}

@end

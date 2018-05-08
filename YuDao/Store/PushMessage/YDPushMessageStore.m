//
//  YDPushMessageStore.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPushMessageStore.h"

@implementation YDPushMessageStore
- (id)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].messageQueue;
    }
    return self;
}

- (BOOL)createSystemMessageTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREAT_PUSH_MESSAGE_TABLE,PUSH_MESSAGE_TABLE_NAME];
    return [self createTable:PUSH_MESSAGE_TABLE_NAME withSQL:sqlString];
}

- (BOOL)createFriendRequestTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREAT_FRIEND_REQUES_TABLE,FRIEND_REQUEST_TABLE_NAME];
    return [self createTable:FRIEND_REQUEST_TABLE_NAME withSQL:sqlString];
}

- (BOOL)addSystemMessage:(YDPushMessage *)message{
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_PUSH_MESSAGE,PUSH_MESSAGE_TABLE_NAME];
    NSArray *arrPara = @[YDNoNilNumber(message.msgid),
                         YDNoNilNumber(message.msgType),
                         YDNoNilNumber(message.msgSubtype),
                         YDNoNilNumber(message.userid),
                         YDNoNilNumber(message.senderid),
                         YDNoNilNumber(message.receiverid),
                         YDNoNilString(message.content),
                         YDNoNilNumber(message.time),
                         YDNoNilString(message.name),
                         YDNoNilString(message.avatar),
                         @(message.readState),
                         @(message.frStatus)];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

- (BOOL)addFriendRequestMessage:(YDPushMessage *)message{
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_PUSH_MESSAGE,FRIEND_REQUEST_TABLE_NAME];
    NSArray *arrPara = @[YDNoNilNumber(message.msgid),
                         YDNoNilNumber(message.msgType),
                         YDNoNilNumber(message.msgSubtype),
                         YDNoNilNumber(message.userid),
                         YDNoNilNumber(message.senderid),
                         YDNoNilNumber(message.receiverid),
                         YDNoNilString(message.content),
                         YDNoNilNumber(message.time),
                         YDNoNilString(message.name),
                         YDNoNilString(message.avatar),
                         @(message.readState),
                         @(message.frStatus)];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

- (BOOL)deleteOnePushMessageByTableName:(NSString *)tableName
                                  msgid:(NSNumber *)msgid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_PUSH_MESSAGE,tableName,msgid];
    return [self excuteCountSql:sqlString];
}

- (void)getFriendRequestMessageByUserid:(NSNumber *)userid
                                  count:(NSUInteger )count
                               complete:(void (^)(NSArray *data, BOOL hasMore))complete{
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_PUSH_MESSAGE_Friend_REQUEST,
                           FRIEND_REQUEST_TABLE_NAME,
                           userid,
                           userid,
                           count+1];
    YDLog(@"好友请求_sqlString = %@",sqlString);
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDPushMessage *message = [self y_createPushMessageByFMResultSet:rsSet];
            [data addObject:message];
        }
        [rsSet close];
    }];
    BOOL hasMore = NO;
    if (data.count == count + 1) {
        hasMore = YES;
        [data removeLastObject];
    }
    complete(data,hasMore);
}

- (void)getSystemMessageByUserid:(NSNumber *)userid
                           count:(NSUInteger )count
                        complete:(void (^)(NSArray *data, BOOL hasMore))complete{
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_PUSH_MESSAGE_SYSTEM,
                           PUSH_MESSAGE_TABLE_NAME,
                           userid,
                           userid,
                           count+1];
    YDLog(@"系统消息_sqlString = %@",sqlString);
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDPushMessage *message = [self y_createPushMessageByFMResultSet:rsSet];
            [data addObject:message];
        }
        [rsSet close];
    }];
    BOOL hasMore = NO;
    if (data.count == count + 1) {
        hasMore = YES;
        [data removeLastObject];
    }
    complete(data,hasMore);
}

- (void)searchFriendRequestMessageByUserid:(NSNumber *)userid
                                senderName:(NSString *)senderName
                                  complete:(void (^)(NSArray *data))complete{
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:SQL_SEARCH_PUSH_MESSAGE_FRIEND_REQUEST,
                           FRIEND_REQUEST_TABLE_NAME,
                           userid,
                           senderName];
    YDLog(@"搜索好友请求_sqlString = %@",sqlString);
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDPushMessage *message = [self y_createPushMessageByFMResultSet:rsSet];
            [data addObject:message];
        }
        [rsSet close];
    }];
    complete(data);
}

- (YDPushMessage *)lastPushMessageByUserid:(NSNumber *)userid{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_LAST_PUSH_MESSAGE_SYSTEM,PUSH_MESSAGE_TABLE_NAME,PUSH_MESSAGE_TABLE_NAME,userid,userid];
    __block YDPushMessage *message;
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            message = [self y_createPushMessageByFMResultSet:rsSet];
        }
        [rsSet close];
    }];
    return message;
}

- (BOOL)deleteSystemMessageByUserid:(NSNumber *)userid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_PUSH_MESSAGE_SYSTEM,PUSH_MESSAGE_TABLE_NAME,userid];
    return [self excuteSQL:sqlString];
}

- (NSUInteger)countFriendRequestMessageByUserid:(NSNumber *)userid{
    NSString *sqlString = [NSString stringWithFormat:SQL_COUNT_PUSH_MESSAGE_Friend_REQUEST,FRIEND_REQUEST_TABLE_NAME,userid,userid];
    return [self excuteCountSql:sqlString];
}

- (NSUInteger)countSystemMessageByUserid:(NSNumber *)userid{
    NSString *sqlString = [NSString stringWithFormat:SQL_COUNT_PUSH_MESSAGE_SYSTEM,PUSH_MESSAGE_TABLE_NAME,userid,userid];
    return [self excuteCountSql:sqlString];
}

- (BOOL)updateFriendRequestMessageToReadByUserid:(NSNumber *)userid{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_PUSH_MESSAGE_Friend_REQUEST,FRIEND_REQUEST_TABLE_NAME,userid,userid];
    YDLog(@"刷新好友请求 sql = %@",sqlString);
    return [self excuteSQL:sqlString];
}

- (BOOL)updateSystemMessageToReadByUserid:(NSNumber *)userid{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_PUSH_MESSAGE_SYSTEM,PUSH_MESSAGE_TABLE_NAME,userid,userid];
    YDLog(@"刷新系统消息 sql = %@",sqlString);
    return [self excuteSQL:sqlString];
}

- (BOOL)updateFriendRequestMessageToAccptedByUserid:(NSNumber *)userid
                                           senderid:(NSNumber *)senderid{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_PUSH_MESSAGE_FRIEND_REQUEST_READ,FRIEND_REQUEST_TABLE_NAME,userid,userid,senderid];
    YDLog(@"刷新好友请求添加 sql = %@",sqlString);
    return [self excuteSQL:sqlString];
}

- (BOOL)deleteRepeatFriendRequestMessageByUserid:(NSNumber *)userid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_REPEAT_PUSH_MESSAGE_FRIEND_REQUEST,userid,userid];
    return [self excuteSQL:sqlString];
}

#pragma mark createPushMessage
- (YDPushMessage *)y_createPushMessageByFMResultSet:(FMResultSet *)reSet{
    YDPushMessage *message = [[YDPushMessage alloc] init];
    message.msgid = @([reSet intForColumn:@"msgid"]);
    message.msgType = @([reSet intForColumn:@"msgtype"]);
    message.msgSubtype = @([reSet intForColumn:@"msgsubtype"]);
    message.userid = @([reSet intForColumn:@"userid"]);
    message.senderid = @([reSet intForColumn:@"senderid"]);
    message.receiverid = @([reSet intForColumn:@"receiverid"]);
    message.content = [reSet stringForColumn:@"content"];
    message.time = @([reSet intForColumn:@"time"]);
    message.name = [reSet stringForColumn:@"name"];
    message.avatar = [reSet stringForColumn:@"avatar"];
    message.readState = [reSet intForColumn:@"readState"];
    message.frStatus = [reSet intForColumn:@"frStatus"];
    
    return message;
}

@end

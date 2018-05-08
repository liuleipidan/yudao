//
//  YDSystemMessageStore.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSystemMessageStore.h"
#import "YDSystemMessageSQL.h"
#import "YDDBManager.h"

@implementation YDSystemMessageStore

- (id)init
{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            YDLog(@"DB: 系统消息表创建失败");
        }
    }
    return self;
}

- (BOOL)createTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREAT_SYSTEM_MESSAGE_TABLE, SYSTEM_MESSAGE_TABLE_NAME];
    return [self createTable:SYSTEM_MESSAGE_TABLE_NAME withSQL:sqlString];
}

- (BOOL)insertSystemMessage:(YDSystemMessage *)message{
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_SYSTEM_MESSAGE,SYSTEM_MESSAGE_TABLE_NAME];
    NSArray *arrPara = @[    YDNoNilNumber(message.msgId),
                             YDNoNilNumber(message.msgType),
                             YDNoNilNumber(message.msgSubtype),
                             YDNoNilNumber(YDUser_id),
                             YDNoNilNumber(message.time),
                             YDNoNilString(message.content),
                             @0];
    return [self excuteSQL:sqlString withArrParameter:arrPara];
}

- (void)messagesByCount:(NSInteger)count
                           complete:(void (^)(NSArray *data, BOOL hasMore))complete{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_SYSTEM_MESSAGE,SYSTEM_MESSAGE_TABLE_NAME,YDUser_id,count+1];
    
    __block NSMutableArray *messages = [NSMutableArray array];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            [messages addObject:[self yd_createSystemMessageBy:rsSet]];
        }
        [rsSet close];
    }];
    
    BOOL hasMore = NO;
    if (messages.count == count + 1) {
        hasMore = YES;
        [messages removeLastObject];
    }
    complete(messages,hasMore);
}

- (NSUInteger)countUnreadSystemMessage{
    NSString *sqlString = [NSString stringWithFormat:SQL_COUNT_UNREAD_SYSTEM_MESSAGE,SYSTEM_MESSAGE_TABLE_NAME,YDUser_id];
    return [self excuteCountSql:sqlString];
}

- (BOOL)updateSystemMessageToRead{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_SYSTEM_MESSAGE,SYSTEM_MESSAGE_TABLE_NAME,YDUser_id];
    return [self excuteSQL:sqlString];
}


- (YDSystemMessage *)newestSystemtMessage{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_LAST_SYSTEM_MESSAGE,SYSTEM_MESSAGE_TABLE_NAME,SYSTEM_MESSAGE_TABLE_NAME,YDUser_id];
    __block YDSystemMessage *message;
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            message = [self yd_createSystemMessageBy:rsSet];
        }
        [rsSet close];
    }];
    return message;
}

- (BOOL)deleteSystemMessageByMsgid:(NSNumber *)msgid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_SYSTEM_MESSAGE,SYSTEM_MESSAGE_TABLE_NAME,msgid,YDUser_id];
    return [self excuteCountSql:sqlString];
}

- (BOOL)deleteAllSystemMessages{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_SYSTEM_MESSAGE,SYSTEM_MESSAGE_TABLE_NAME,YDUser_id];
    return [self excuteSQL:sqlString];
}

#pragma mark - Private Methods
- (YDSystemMessage *)yd_createSystemMessageBy:(FMResultSet *)rsSet{
    YDSystemMessage *message = [[YDSystemMessage alloc] init];
    message.msgId = @([rsSet intForColumn:@"msgid"]);
    message.msgType = @([rsSet intForColumn:@"msgtype"]);
    message.msgSubtype = @([rsSet intForColumn:@"msgsubtype"]);
    message.time = @([rsSet intForColumn:@"time"]);
    message.content = [rsSet stringForColumn:@"content"];
    
    return message;
}

@end

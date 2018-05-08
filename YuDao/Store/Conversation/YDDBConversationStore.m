//
//  YDDBConversationStore.m
//  YuDao
//
//  Created by 汪杰 on 16/11/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBConversationStore.h"
#import "YDDBConversationSQL.h"
#import "YDDBManager.h"
@interface YDDBConversationStore()


@end

@implementation YDDBConversationStore

- (id)init
{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].messageQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            YDLog(@"DB: 聊天记录表创建失败");
        }
    }
    return self;
}

- (BOOL)createTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_CONV_TABLE, CONV_TABLE_NAME];
    return [self createTable:CONV_TABLE_NAME withSQL:sqlString];
}

/**
 *  新的会话（未读）
 */
- (BOOL)addConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid type:(NSInteger)type date:(NSDate *)date{
    NSInteger unreadCount = [self unreadMessageByUid:uid fid:fid] + 1;
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_CONV, CONV_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        YDNoNilNumber(uid),
                        YDNoNilNumber(fid),
                        [NSNumber numberWithInteger:type],
                        YDTimeStamp(date),
                        [NSNumber numberWithInteger:unreadCount],
                        @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

/**
 *  新的会话
 */
- (BOOL)addConversationByModel:(YDConversation *)conversation{
    NSNumber *uid = [YDUserDefault defaultUser].user.ub_id;
    YDConversation *oldConverSation = [self getOneConversationWithUid:uid fid:conversation.fid];
    if (oldConverSation && oldConverSation.fid.integerValue != 0) {
        conversation.unreadCount += oldConverSation.unreadCount;
        conversation.fname = conversation.fname.length > 0 ? conversation.fname : oldConverSation.fname;
        conversation.fimageUrl = conversation.fimageUrl.length > 0 ? conversation.fimageUrl : oldConverSation.fimageUrl;
    }
    
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_CONV,CONV_TABLE_NAME];
    NSArray *arrPara = @[    uid,
                           YDNoNilNumber(conversation.fid),
                           YDNoNilString(conversation.fname),
                           YDNoNilString(conversation.fimageUrl),
                           YDNoNilString(conversation.content),
                           @(conversation.convType),
                           YDTimeStamp(conversation.date),
                           @(conversation.unreadCount)];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

/**
 *  获取一条会话
 */
- (YDConversation *)getOneConversationWithUid:(NSNumber *)uid fid:(NSNumber *)fid{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_ONE_CONVS,CONV_TABLE_NAME,uid,fid];
    __block YDConversation *conv = nil;
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            conv = [self createByReSet:rsSet];
        }
        [rsSet close];
    }];
    return conv;
}

- (YDConversation *)createByReSet:(FMResultSet *)reSet{
    YDConversation *conv = [[YDConversation alloc] init];
    conv.uid = @([reSet intForColumn:@"uid"]);
    conv.fid = @([reSet intForColumn:@"fid"]);
    conv.fname = [reSet stringForColumn:@"fname"];
    conv.fimageUrl = [reSet stringForColumn:@"fimage"];
    conv.content = [reSet stringForColumn:@"content"];
    conv.convType = [reSet intForColumn:@"conv_type"];
    
    NSString *dateString = [reSet stringForColumn:@"date"];
    conv.date = [NSDate dateFromTimeStamp:dateString];
    conv.unreadCount = [reSet intForColumn:@"unread_count"];
    
    return conv;
}

/**
 *  更新会话状态（已读）
 */
- (BOOL)updateConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_CONVS,CONV_TABLE_NAME,uid,fid];
    return [self excuteSQL:sqlString];
}

/**
 *  查询所有会话
 */
- (NSArray *)conversationsByUid:(NSNumber *)uid{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_CONVS, CONV_TABLE_NAME, uid];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            YDConversation *conversation =  [self createByReSet:retSet];
            [data addObject:conversation];
        }
        [retSet close];
    }];
    return data;
}

/**
 *  单个聊天未读消息数
 */
- (NSInteger)unreadMessageByUid:(NSNumber *)uid fid:(NSNumber *)fid{
    __block NSInteger unreadCount = 0;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CONV_UNREAD, CONV_TABLE_NAME, uid, fid];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        if ([retSet next]) {
            unreadCount = [retSet intForColumn:@"unread_count"];
        }
        [retSet close];
    }];
    return unreadCount;
}

/**
 *  所有未读消息数
 */
- (NSInteger)allUnreadMessageByUid:(NSNumber *)uid{
    __block NSInteger unreadCount = 0;
    NSString *sqlString = [NSString stringWithFormat:SQL_SUM_CONV_UNREADCOUNT,CONV_TABLE_NAME,uid];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        if ([rsSet next]) {
            unreadCount = [rsSet intForColumnIndex:0];
        }
        [rsSet close];
    }];
    return unreadCount;
}

/**
 *  删除单条会话
 */
- (BOOL)deleteConversationByUid:(NSNumber *)uid fid:(NSNumber *)fid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_CONV, CONV_TABLE_NAME, uid, fid];
    YDLog(@"删除单条会话 sqlString = %@",sqlString);
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

/**
 *  删除用户的所有会话
 */
- (BOOL)deleteConversationsByUid:(NSNumber *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_CONVS, CONV_TABLE_NAME, uid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}


@end

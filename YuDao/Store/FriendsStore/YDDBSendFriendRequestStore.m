//
//  YDDBSendFriendRequestStore.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBSendFriendRequestStore.h"
#import "YDDBBaseStore.h"
#import "YDDBSendFriendRequestSQL.h"

@implementation YDDBSendFriendRequestStore

+ (void)createBaseStoreCompletion:(void (^)(YDDBBaseStore *baseStore))completion{
    YDDBBaseStore *baseStore = [YDDBBaseStore new];
    baseStore.dbQueue = [YDDBManager sharedInstance].commonQueue;
    NSString *sqlString  = [NSString stringWithFormat:SQL_CREATE_ADD_FRIENDS_TABLE,SEND_FRIEND_REQUEST_TABLE_NAME];
    if ([baseStore createTable:SQL_CREATE_ADD_FRIENDS_TABLE withSQL:sqlString]) {
        if (completion) {
            completion(baseStore);
        }
    }else{
        YDLog(@"创建发送好友请求表失败");
    }
}

+ (void)insertSenderFriendRequestSenderID:(NSNumber *)senderID
                               receiverID:(NSNumber *)receiverID{
    [YDDBSendFriendRequestStore createBaseStoreCompletion:^(YDDBBaseStore *baseStore) {
        NSString *sqlString = [NSString stringWithFormat:SQL_INSERT_FRIEND_REQUEST,SEND_FRIEND_REQUEST_TABLE_NAME];
        //NSDictionary *dicPara = @{@"senderID":senderID,@"receiverID":receiverID};
        NSArray *arrPara = @[senderID,receiverID,YDTimeStamp([NSDate date])];
        if ([baseStore excuteSQL:sqlString withArrParameter:arrPara]) {
            YDLog(@"插入发送好友请求成功");
        }else{
            YDLog(@"插入发送好友请求失败");
        }
    }];
}

+ (BOOL)checkSenderFriendRequsetExistOrNeedDeleteBySenderID:(NSNumber *)senderID
                                                 receiverID:(NSNumber *)receiverID{
    __block BOOL exists = NO;
    [YDDBSendFriendRequestStore createBaseStoreCompletion:^(YDDBBaseStore *baseStore) {
        NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CHECK_REQUEST,SEND_FRIEND_REQUEST_TABLE_NAME,senderID,receiverID];
        __block NSDate *date = nil;
        [baseStore excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
            while ([rsSet next]) {
                NSString *timeStr = [rsSet stringForColumn:@"time"];
                if (timeStr) {
                    date = [NSDate dateFromTimeStamp:timeStr];
                }
            }
            [rsSet close];
        }];
        if (date) {
            NSUInteger day = [NSDate differFirstDate:[NSDate date] secondDate:date differType:YDDifferDateTypeDay];
            if (day >= 3) {
                NSString *deleteSqlString = [NSString stringWithFormat:SQL_DELETE_FRIEND_REQUEST,SEND_FRIEND_REQUEST_TABLE_NAME,senderID,receiverID];
                BOOL ok = [baseStore excuteSQL:deleteSqlString];
                if (ok) {
                    YDLog(@"删除发送好友请求成功");
                }else{
                    YDLog(@"删除发送好友请求失败");
                }
            }else{
                exists = YES;
            }
        }
    }];
    return exists;
}

+ (void)deleteSenderFriendRequestSenderID:(NSNumber *)senderID
                               receiverID:(NSNumber *)receiverID{
    [YDDBSendFriendRequestStore createBaseStoreCompletion:^(YDDBBaseStore *baseStore) {
        NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_FRIEND_REQUEST,SEND_FRIEND_REQUEST_TABLE_NAME,senderID,receiverID];
        BOOL ok = [baseStore excuteSQL:sqlString];
        if (ok) {
            YDLog(@"删除发送好友请求成功");
        }else{
            YDLog(@"删除发送好友请求失败");
        }
    }];
}

@end

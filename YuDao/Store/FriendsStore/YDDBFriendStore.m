//
//  YDFriendStore.m
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBFriendStore.h"
#import "YDDBFriendSQL.h"
#import "YDDBManager.h"
#import "NSObject+Category.h"

@implementation YDDBFriendStore

- (id)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            YDLog(@"DB:好友表创建失败");
        }
    }
    return self;
}

- (BOOL)createTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_FRIENDS_TABLE, FRIENDS_TABLE_NAME];
    return [self createTable:FRIENDS_TABLE_NAME withSQL:sqlString];
}

- (BOOL)addFriend:(YDFriendModel *)user{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_FRIEND, FRIENDS_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        YDNoNilNumber(user.friendid),
                        YDNoNilNumber(user.currentUserid),
                        YDNoNilString(user.friendImage),
                        YDNoNilString(user.friendName),
                        YDNoNilNumber(user.friendGrade),
                        YDNoNilString(user.firstchar),nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

- (BOOL)deleteFriendByFid:(NSNumber *)fid forUid:(NSNumber *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_FRIEND, FRIENDS_TABLE_NAME, uid.integerValue, fid.integerValue];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

- (BOOL)deleteAllFriends{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_FRIENDS,FRIENDS_TABLE_NAME,[YDUserDefault defaultUser].user.ub_id];
    return [self excuteSQL:sqlString, nil];
}

//f_ub_id, ud_face, ub_nickname, ub_auth_grade, f_firstchar, ub_id
- (NSMutableArray *)friendsDataByUid:(NSNumber *)uid{
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_FRIENDS, FRIENDS_TABLE_NAME, uid.integerValue];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            YDFriendModel *user = [self y_createFriendBy:retSet];
            
            [data addObject:user];
        }
        [retSet close];
    }];
    
    return data;
}

- (YDFriendModel *)friendByUid:(NSNumber *)uid friendId:(NSNumber *)fid{
    __block YDFriendModel *friend = nil;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_FRIEND,FRIENDS_TABLE_NAME,uid,fid];
    YDLog(@"sqlString = %@",sqlString);
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            friend = [self y_createFriendBy:rsSet];
        }
    }];
    return friend;
}

/**
 *  查询是否存在此好友
 *
 */
- (BOOL )friendIsInExistenceByUid:(NSNumber *)uid{
    __block BOOL exist = NO;
    NSString *sqlString = [NSString stringWithFormat:@"select * from friends where  currentUserid = %@ and friendid = '%@'",YDUser_id,uid];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            exist = YES;
        }
        [rsSet close];
        
    }];
    return exist;
}

/**
 *  查询好友,通过名字或者id
 */
- (void )searchFriendByName:(NSString *)name orId:(NSNumber *)fid completion:(void (^)(NSArray *data))completion{
    NSString *sqlString = [NSString stringWithFormat:@"select * from friends where 1=1 and  currentUserid=%@",YDUser_id];
    if (name) {
        NSString *nameString = [NSString stringWithFormat:@" and friendName like '%%%@%%'",name];
        sqlString = [sqlString stringByAppendingString:nameString];
    }
    if (fid) {
        NSString *idString = [NSString stringWithFormat:@" or friendid = '%@'",fid];
        sqlString = [sqlString stringByAppendingString:idString];
    }
    
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDFriendModel *user = [self y_createFriendBy:rsSet];
            [data addObject:user];
        }
        [rsSet close];
        if (completion) {
            completion(data);
        }
    }];
}

- (YDFriendModel *)y_createFriendBy:(FMResultSet *)rsSet{
    YDFriendModel *user = [[YDFriendModel alloc] init];
    user.friendid = [NSNumber numberWithInt:[rsSet intForColumn:@"friendid"]];
    user.friendImage = [rsSet stringForColumn:@"friendImage"];
    user.friendName = [rsSet stringForColumn:@"friendName"];
    user.friendGrade = [NSNumber numberWithInt:[rsSet intForColumn:@"friendGrade"]];
    user.firstchar = [rsSet stringForColumn:@"firstchar"];
    user.currentUserid = [NSNumber numberWithInt:[rsSet intForColumn:@"currentUserid"]];
    return user;
}

- (NSInteger)countAllFriends{
    NSString *sqlString = [NSString stringWithFormat:@"select count(*) from %@ where currentUserid = %@",FRIENDS_TABLE_NAME,[YDUserDefault defaultUser].user.ub_id];
    NSUInteger count =  [self excuteCountSql:sqlString];
    return count;
}

@end

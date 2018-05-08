//
//  YDDBUserStore.m
//  YuDao
//
//  Created by 汪杰 on 16/11/7.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBUserStore.h"
#import "YDDBUserSQL.h"
#import "YDDBManager.h"

@implementation YDDBUserStore

- (id)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
        if (![self createTable]) {
            YDLog(@"创建用户表失败!");
        }
    }
    return self;
}

- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_USER_TABLE,USER_TABLE_NAME];
    return [self createTable:USER_TABLE_NAME withSQL:sqlString];
}

- (BOOL)insertOrUpdateUserByUser:(YDUser *)user{
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_USER,USER_TABLE_NAME];
    
    NSArray *arrayPara = [NSArray arrayWithObjects:
                          user.ub_id,
                          user.access_token,
                          user.ub_name,
                          user.ub_nickname,
                          user.ub_cellphone,
                          user.ub_password,
                          user.ud_face,
                          user.ud_realname,
                          user.ud_age,
                          user.ud_sex,
                          user.ud_emotion,
                          user.ud_tag_name,
                          user.ud_userauth,
                          user.ud_often_province,
                          user.ud_often_province_name,
                          user.ud_often_city,
                          user.ud_often_city_name,
                          user.ud_often_area,
                          user.ud_often_area_name,
                          user.ud_tag,
                          user.ud_age_display,
                          user.ud_constellation,
                          nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrayPara];
    return ok;
}

- (void)getCurrentUser:(NSNumber *)uid currentUser:(YDUser *)user{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_USER,USER_TABLE_NAME,[uid integerValue]];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *reSet) {
        while ([reSet next]) {
            user.ub_id = [NSNumber numberWithInt:[reSet intForColumn:@"ub_id"]];
            user.access_token = [reSet stringForColumn:@"access_token"];
            user.ub_name = [reSet stringForColumn:@"ub_name"];
            user.ub_nickname = [reSet stringForColumn:@"ub_nickname"];
            user.ub_cellphone = [reSet stringForColumn:@"ub_cellphone"];
            user.ub_password = [reSet stringForColumn:@"ub_password"];
            user.ud_face = [reSet stringForColumn:@"ud_face"];
            user.ud_realname = [reSet stringForColumn:@"ud_realname"];
            user.ud_age = [NSNumber numberWithInt:[reSet intForColumn:@"ud_age"]];
            user.ud_sex = [NSNumber numberWithInt:[reSet intForColumn:@"ud_sex"]];
            user.ud_emotion = [NSNumber numberWithInt:[reSet intForColumn:@"ud_emotion"]];
            user.ud_tag_name = [reSet stringForColumn:@"ud_tag_name"];
            user.ud_userauth = [NSNumber numberWithInt:[reSet intForColumn:@"ud_userauth"]];
            user.ud_often_province = [NSNumber numberWithInt:[reSet intForColumn:@"ud_often_province"]];
            user.ud_often_province_name = [reSet stringForColumn:@"ud_often_province_name"];
            user.ud_often_city = [NSNumber numberWithInt:[reSet intForColumn:@"ud_often_city"]];
            user.ud_often_city_name = [reSet stringForColumn:@"ud_often_city_name"];
            user.ud_often_area = [NSNumber numberWithInt:[reSet intForColumn:@"ud_often_area"]];
            user.ud_often_area_name = [reSet stringForColumn:@"ud_often_area_name"];
            user.ud_tag = [reSet stringForColumn:@"ud_tag"];
            user.ud_age_display = [NSNumber numberWithInt:[reSet intForColumn:@"ud_age_display"]];
            user.ud_constellation = [reSet stringForColumn:@"ud_constellation"];
        }
        [reSet close];
    }];
}

- (BOOL)deleteUserByUid:(NSString *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_USER, USER_TABLE_NAME, uid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

- (BOOL)deleteUsers{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_USERS, USER_TABLE_NAME];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

@end

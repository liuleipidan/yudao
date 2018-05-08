//
//  YDDBBaseStore.m
//  YuDao
//
//  Created by 汪杰 on 16/10/25.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "FMDatabaseAdditions.h"

@implementation YDDBBaseStore

- (id)init
{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
    }
    return self;
}

- (BOOL)tableExists:(NSString *)tableName{
    __block BOOL exist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        exist = [db tableExists:tableName];
    }];
    return exist;
}

- (BOOL)createTable:(NSString *)tableName withSQL:(NSString *)sqlString
{
    __block BOOL ok = YES;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if(![db tableExists:tableName]){
            ok = [db executeUpdate:sqlString withArgumentsInArray:nil];
        }
    }];
    return ok;
}

- (BOOL)deleteTable:(NSString *)tableName{
    __block BOOL ok = YES;
    if (self.dbQueue) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([db tableExists:tableName]) {
                NSString *sqlString = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
                ok = [db executeUpdate:sqlString];
            }
        }];
    }
    
    return ok;
}

- (BOOL)excuteSQL:(NSString *)sqlString withArrParameter:(NSArray *)arrParameter
{
    __block BOOL ok = NO;
    if (self.dbQueue) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withArgumentsInArray:arrParameter];
        }];
    }
    return ok;
}

- (BOOL)excuteSQL:(NSString *)sqlString withDicParameter:(NSDictionary *)dicParameter
{
    __block BOOL ok = NO;
    if (self.dbQueue) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withParameterDictionary:dicParameter];
        }];
    }
    return ok;
}

- (BOOL)excuteSQL:(NSString *)sqlString,...
{
    __block BOOL ok = NO;
    if (self.dbQueue) {
        va_list args;
        va_list *p_args;
        p_args = &args;
        va_start(args, sqlString);
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withVAList:*p_args];
        }];
        va_end(args);
    }
    return ok;
}

- (void)excuteQuerySQL:(NSString*)sqlStr resultBlock:(void(^)(FMResultSet * rsSet))resultBlock
{
    if (self.dbQueue) {
        [_dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet * retSet = [db executeQuery:sqlStr];
            if (resultBlock) {
                resultBlock(retSet);
            }
        }];
    }
}

/**
 *  统计
 */
- (NSUInteger )excuteCountSql:(NSString *)sqlStr{
    if (self.dbQueue) {
        __block NSUInteger count = 0;
        [_dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet * retSet = [db executeQuery:sqlStr];
            while ([retSet next]) {
                count = [retSet intForColumnIndex:0];
            }
        }];
        return count;
    }
    return 0;
}

- (void)addColumWithTableName:(NSString *)tableName
                    columName:(NSString *)columName
                    columType:(NSString *)cloumType
                 defaultValue:(NSString *)dfValue{
    if (self.dbQueue) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            BOOL exist = [db columnExists:columName inTableWithName:tableName];
            if (!exist) {
                NSString *alterStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",tableName,columName,cloumType];
                BOOL ok = [db executeUpdate:alterStr];
                if (ok) {
                    YDLog(@"表 %@ 增加字段 %@ 成功",tableName,columName);
                }else{
                    YDLog(@"表 %@ 增加字段 %@ 失败",tableName,columName);
                }
                /*
                 #define SQL_UPDATE_PUSH_MESSAGE_Friend_REQUEST  @"UPDATE %@ SET readState = 1 WHERE msgtype = 2 and msgsubtype = 1001 and userid = %@ and receiverid = %@"
                 */
                NSString *defaultValueStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@'",tableName,columName,dfValue];
                ok = [db executeUpdate:defaultValueStr];
                if (ok) {
                    YDLog(@"新字段 %@ 设置默认值成功",columName);
                }else{
                    YDLog(@"新字段 %@ 设置默认值失败",columName);
                }
            }
        }];
    }
}

@end

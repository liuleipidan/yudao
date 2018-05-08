//
//  YDDBPlaceStore.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/26.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBPlaceStore.h"
#import "YDDBPlaceSQL.h"

@implementation YDPlace

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"currentId":@"Id",
             @"pId":@"Pid",
             @"name":@"Name"
             };
}

@end

@implementation YDDBPlaceStore

- (id)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].sysCommonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            YDLog(@"DB:省市区表创建失败");
        }
    }
    return self;
}

- (BOOL)placeTableExist{
    NSArray *data = [self placesByCurrentId:@0];
    return data.count > 0 ? YES : NO;
}

- (BOOL)createTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_PLACE_TABLE, PLACE_TABLE_NAME];
    return [self createTable:PLACE_TABLE_NAME withSQL:sqlString];
}

- (BOOL)addPlace:(YDPlace *)model{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_PLACE, PLACE_TABLE_NAME];
    
    NSArray *arrPara = [NSArray arrayWithObjects:
                        YDNoNilNumber(model.currentId),
                        YDNoNilNumber(model.pId),
                        YDNoNilString(model.name),nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

- (BOOL)deleteAllPlaces{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_PLACE,PLACE_TABLE_NAME];
    return [self excuteSQL:sqlString, nil];
}

- (BOOL)insertPlaces:(NSArray<YDPlace *> *)places{
    if (places.count == 0) {
        return NO;
    }
    if (![self deleteAllPlaces]) {
        YDLog(@"删除所有省市区数据失败!");
    }
    
    __block BOOL isRollBack = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        @try {
            [places enumerateObjectsUsingBlock:^(YDPlace * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_PLACE, PLACE_TABLE_NAME];
                NSArray *arrPara = [NSArray arrayWithObjects:
                                    YDNoNilNumber(obj.currentId),
                                    YDNoNilNumber(obj.pId),
                                    YDNoNilString(obj.name),nil];
                BOOL ok = [db executeUpdate:sqlString withArgumentsInArray:arrPara];
                if (!ok) {
                    YDLog(@"插入省市区失败");
                }
            }];
        } @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        } @finally {
            if (!isRollBack) {
                [db commit];
            }
        }
        //无须关闭
        //[db close];
    }];
    
    return !isRollBack;
}

- (NSUInteger)countPlaces{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_COUNT_PLACE,PLACE_TABLE_NAME];
    return [self excuteCountSql:sqlString];
}

- (NSArray *)provinces{
    __block NSMutableArray *tempArr = [NSMutableArray array];
    
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_PLACE_PROVINCES, PLACE_TABLE_NAME];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            YDPlace *place = [self yd_createPlaceBy:retSet];
            [tempArr addObject:place];
        }
        [retSet close];
    }];
    
    return [NSArray arrayWithArray:tempArr];
}

- (NSArray *)placesByCurrentId:(NSNumber *)currentId{
    __block NSMutableArray *tempArr = [NSMutableArray array];
    
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_PLACE, PLACE_TABLE_NAME, currentId];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            YDPlace *place = [self yd_createPlaceBy:retSet];
            [tempArr addObject:place];
        }
        [retSet close];
    }];
    
    return [NSArray arrayWithArray:tempArr];
}

#pragma mark - Private Methods
- (YDPlace *)yd_createPlaceBy:(FMResultSet *)retset{
    YDPlace *place = [[YDPlace alloc] init];
    place.currentId = @([retset intForColumn:@"currentid"]);
    place.pId = @([retset intForColumn:@"pid"]);
    place.name = [retset stringForColumn:@"name"];
    return place;
}

@end

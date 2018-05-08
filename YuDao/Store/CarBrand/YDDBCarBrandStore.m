//
//  YDDBCarBrandStore.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDBCarBrandStore.h"
#import "YDDBCarBrandStoreSQL.h"

@implementation YDDBCarBrandStore

+ (YDDBCarBrandStore *)manager{
    return [[self alloc] init];
}

- (id)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].sysCommonQueue;
        if (![self createTable]) {
            YDLog(@"DB:创建车辆品牌表失败");
        }
        
    }
    return self;
}

- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_PLACE_TABLE,CARBRAND_TABLE_NAME];
    return [self createTable:CARBRAND_TABLE_NAME withSQL:sqlString];
}

- (BOOL)insertCarBrand:(YDCarBrand *)brand{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_CARBRAND,CARBRAND_TABLE_NAME];
    NSArray *arrPara = @[
                         YDNoNilNumber(brand.vb_id),
                         YDNoNilString(brand.vb_name),
                         YDNoNilString(brand.firstletter),
                         YDNoNilString(brand.logo),
                         YDNoNilNumber(brand.disabled)
                         ];
    
    return [self excuteSQL:sqlString withArrParameter:arrPara];
}

- (BOOL)deleteAllCarBrand{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_CARBRAND,CARBRAND_TABLE_NAME];
    return [self excuteSQL:sqlString];
}

- (BOOL)insertCarBrands:(NSArray<YDCarBrand *> *)brands{
    if (brands.count == 0) {
        return NO;
    }
    if (![self deleteAllCarBrand]) {
        YDLog(@"删除所有车辆品牌失败");
    }
    
    __block BOOL isRollBack = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        @try {
            [brands enumerateObjectsUsingBlock:^(YDCarBrand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_CARBRAND,CARBRAND_TABLE_NAME];
                NSArray *arrPara = @[
                                     YDNoNilNumber(obj.vb_id),
                                     YDNoNilString(obj.vb_name),
                                     YDNoNilString(obj.firstletter),
                                     YDNoNilString(obj.logo),
                                     YDNoNilNumber(obj.disabled)
                                     ];
                BOOL ok = [db executeUpdate:sqlString withArgumentsInArray:arrPara];
                if (!ok) {
                    YDLog(@"插入车辆品牌失败");
                }
            }];
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            if (!isRollBack) {
                [db commit];
            }
        }
        //无须关闭
        //[db close];
    }];
   
    return !isRollBack;
}

- (NSUInteger)countCarBrands{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_COUNT_CARBRAND,CARBRAND_TABLE_NAME];
    return [self excuteCountSql:sqlString];
}

- (NSArray *)carBrands{
    __block NSMutableArray *tempArr = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CARBRAND,CARBRAND_TABLE_NAME];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            [tempArr addObject:[self yd_createCarBrandBy:rsSet]];
        }
        [rsSet close];
    }];
    return [NSArray arrayWithArray:tempArr];
}

#pragma mark - Private Methods
- (YDCarBrand *)yd_createCarBrandBy:(FMResultSet *)rsSet{
    YDCarBrand *brand = [[YDCarBrand alloc] init];
    brand.vb_id = @([rsSet intForColumn:@"brand_id"]);
    brand.vb_name = [rsSet stringForColumn:@"brand_name"];
    brand.firstletter = [rsSet stringForColumn:@"brand_firstletter"];
    brand.logo = [rsSet stringForColumn:@"brand_logo"];
    brand.disabled = @([rsSet intForColumn:@"disabled"]);
    return brand;
}

@end

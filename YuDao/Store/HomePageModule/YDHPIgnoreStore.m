//
//  YDHPIgnoreStore.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPIgnoreStore.h"
#import "YDHPIgnoreStoreSQL.h"

@implementation YDHPIgnoreStore

+ (YDHPIgnoreStore *)manager{
    return [[YDHPIgnoreStore alloc] init];
}

- (instancetype)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
        if (![self createTable]) {
            
        }
    }
    return self;
}

- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_HOME_PAGE_MODULE_TABLE,HOME_PAGE_MODULE_TABLE_NAME];
    return  [self createTable:HOME_PAGE_MODULE_TABLE_NAME withSQL:sqlString];
}

- (void)addHPIgnoreArray:(NSArray<YDHPIgnoreModel *> *)arr userId:(NSNumber *)uid{
    if (arr == nil || uid == nil) {
        return;
    }
    //删除当前用户以前的记录
    if (![self deleteAllHPIgnoreByUserId:uid]) {
        YDLog(@"删除记录失败！");
    }
    //插入最新数据
    [arr enumerateObjectsUsingBlock:^(YDHPIgnoreModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self addHPIgnoreModel:obj]) {
            YDLog(@"插入首页忽略失败");
        }
    }];
}

- (BOOL)addHPIgnoreModel:(YDHPIgnoreModel *)model{
    if (model == nil || model.rid == nil || model.uid == nil) {
        return NO;
    }
    NSString *sqlString = [NSString stringWithFormat:SQL_INSERT_HOME_PAGE_MODULE,HOME_PAGE_MODULE_TABLE_NAME];
    NSArray *para = @[ model.rid,
                      model.uid,
                      model.ptype,
                      YDNoNilNumber(model.subtype),
                      YDNoNilNumber(model.ignore_type),
                      YDNoNilString(model.time)];
    return [self excuteSQL:sqlString withArrParameter:para];
}

- (BOOL)deleteHPIgnore:(NSNumber *)rid userId:(NSNumber *)uid{
    if (rid == nil || uid == nil) {
        return NO;
    }
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_HOME_PAGE_MODULE,HOME_PAGE_MODULE_TABLE_NAME,rid,uid];
    return [self excuteSQL:sqlString];
}

- (BOOL)deleteAllHPIgnoreByUserId:(NSNumber *)uid{
    if (uid == nil) {
        return NO;
    }
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_CURRENT_USER_ALL,HOME_PAGE_MODULE_TABLE_NAME,uid];
    return [self excuteSQL:sqlString];
}

- (YDHPIgnoreModel *)checkIgnoreListIsExistByUserId:(NSNumber *)uid
                                 ptype:(NSInteger )ptype
                               subtype:(NSInteger )subtype
                           ignore_type:(NSInteger )ignore_type{
    __block YDHPIgnoreModel *model = nil;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CHECK_HOME_PAGE_TYPE_SUBTYPE,HOME_PAGE_MODULE_TABLE_NAME,uid,ptype,subtype,ignore_type];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            model = [self y_createHPIgnoreModelByFMResult:rsSet];
        }
        [rsSet close];
    }];
    return model;
}

- (YDHPIgnoreModel *)checkIgnoreModelByUserId:(NSNumber *)uid
                                        ptype:(NSInteger )ptype
                                      subtype:(NSInteger )subtype{
    __block YDHPIgnoreModel *model = nil;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CHECK_HOME_PAGE_MODEL,HOME_PAGE_MODULE_TABLE_NAME,uid,ptype,subtype];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            model = [self y_createHPIgnoreModelByFMResult:rsSet];
        }
        [rsSet close];
    }];
    return model;
}

- (NSArray *)ignoreListByUserId:(NSNumber *)uid{
    if (uid == nil) {
        return nil;
    }
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_HOME_PAGE_IGNORE_LIST,HOME_PAGE_MODULE_TABLE_NAME,uid];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDHPIgnoreModel *model = [self y_createHPIgnoreModelByFMResult:rsSet];
            [data addObject:model];
        }
        [rsSet close];
    }];
    return data;
}

+ (BOOL)checkTwentyFourHoursMessagesIngnoreBySubtype:(NSInteger)subtype{
    YDHPIgnoreModel *messageIgnore = YDCheckHPIgnoreModel(YDUser_id, 3, subtype);
    if (messageIgnore && [messageIgnore.ignore_type isEqual:@1]) {
        NSDate *date = [NSDate stringToDate:messageIgnore.time withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSUInteger hour = [NSDate differFirstDate:[NSDate date] secondDate:date differType:YDDifferDateTypeHour];
        if (hour >= 24) {
            return YES;
        }
        return NO;
    }
    else if (messageIgnore && [messageIgnore.ignore_type isEqual:@2]){//永久
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - Private Method
- (YDHPIgnoreModel *)y_createHPIgnoreModelByFMResult:(FMResultSet *)reset{
    YDHPIgnoreModel *model = [[YDHPIgnoreModel alloc] init];
    model.rid = @([reset intForColumn:@"rid"]);
    model.uid = @([reset intForColumn:@"uid"]);
    model.ptype = @([reset intForColumn:@"ptype"]);
    model.subtype = @([reset intForColumn:@"subtype"]);
    model.ignore_type = @([reset intForColumn:@"ignore_type"]);
    model.time = [reset stringForColumn:@"time"];
    return model;
}

@end

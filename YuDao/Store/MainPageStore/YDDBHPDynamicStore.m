//
//  YDDBHPDynamicStore.m
//  YuDao
//
//  Created by 汪杰 on 2017/4/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBHPDynamicStore.h"

#define     HPDYNAMIC_TABLE_NAME             @"homePageDynamic"

#define     SQL_CREATE_HPDYNAMICT_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
                                                            dorder  INTEGER,\
                                                            d_id  INTEGER,\
                                                            ub_id INTEGER,\
                                                            u_name TEXT,\
                                                            ud_face TEXT,\
                                                            d_image TEXT,\
                                                            d_label TEXT,\
                                                            d_details TEXT,\
                                                            d_address TEXT,\
                                                            PRIMARY KEY(dorder))"
#define     SQL_REPLACE_HPDYNAMIC           @"REPLACE INTO %@ ( dorder, d_id, ub_id, u_name, ud_face, d_image, d_label, d_details, d_address) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define     SQL_SELECT_ALL_HPDYNAMIC        @"SELECT * FROM %@ "

#define     SQL_DELETE_ALL_HPDYNAMIC        @"DELETE FROM %@ "

static YDDBHPDynamicStore *hpDynamicStore = nil;

@implementation YDDBHPDynamicStore

+ (instancetype)shareHPDynamic{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hpDynamicStore = [[YDDBHPDynamicStore alloc] init];
    });
    return hpDynamicStore;
}

- (id)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
        if (![self createTable]) {
            YDLog(@"创建首页动态表失败!");
        }else{
            YDLog(@"创建首页动态表成功!");
        }
    }
    return self;
}

- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_HPDYNAMICT_TABLE,HPDYNAMIC_TABLE_NAME];
    return [self createTable:HPDYNAMIC_TABLE_NAME withSQL:sqlString];
}

#pragma mark - Public Methods
+ (void)insertHPDynamicData:(NSArray <YDDynamicModel *> *)data{
    [self shareHPDynamic];
    if ([hpDynamicStore deleteAllHPDynamic]) {
        YDLog(@"首页动态删除成功");
    }else{
        YDLog(@"首页动态删除失败");
    }
    if (data) {
        [data enumerateObjectsUsingBlock:^(YDDynamicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![hpDynamicStore insertSingleHPDynamic:obj order:@(idx)]) {
                YDLog(@"插入首页动态失败");
            }
        }];
    }
}

+ (NSArray *)selectAllHPDynamicData{
    [self shareHPDynamic];
    __block NSMutableArray *data = [NSMutableArray arrayWithCapacity:5];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_ALL_HPDYNAMIC,HPDYNAMIC_TABLE_NAME];
    
    [hpDynamicStore excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDDynamicModel *model = [hpDynamicStore createHPDynamicModel:rsSet];
            
            [data addObject:model];
        }
        [rsSet close];
    }];
    return data;
}

#pragma mark - Private Methods
//删除首页动态
- (BOOL)deleteAllHPDynamic{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_HPDYNAMIC,HPDYNAMIC_TABLE_NAME];
    return [hpDynamicStore excuteSQL:sqlString];
}

//插入单条动态
- (BOOL)insertSingleHPDynamic:(YDDynamicModel *)model order:(NSNumber *)order{

    NSString *sqlString = [NSString stringWithFormat:SQL_REPLACE_HPDYNAMIC,HPDYNAMIC_TABLE_NAME];
    NSArray *arrayPara = @[    order,
                           YDNoNilNumber(model.d_id),
                           YDNoNilNumber(model.ub_id),
                           YDNoNilString(model.u_name),
                           YDNoNilString(model.ud_face),
                           YDNoNilString(model.d_image),
                           YDNoNilString(model.d_label),
                           YDNoNilString(model.d_details),
                           YDNoNilString(model.d_address)];
    
    return [hpDynamicStore excuteSQL:sqlString withArrParameter:arrayPara];
}

//创建动态数据模型
- (YDDynamicModel *)createHPDynamicModel:(FMResultSet *)reset{
    YDDynamicModel *model = [[YDDynamicModel alloc] init];
    model.d_id = @([reset intForColumn:@"d_id"]);
    model.ub_id = @([reset intForColumn:@"ub_id"]);
    model.u_name = [reset stringForColumn:@"u_name"];
    model.ud_face = [reset stringForColumn:@"ud_face"];
    model.d_image = [reset stringForColumn:@"d_image"];
    model.d_label = [reset stringForColumn:@"d_label"];
    model.d_details = [reset stringForColumn:@"d_details"];
    model.d_address = [reset stringForColumn:@"d_address"];
    
    return model;
}

@end

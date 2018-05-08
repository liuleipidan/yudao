//
//  YDDBHPRankListStore.m
//  YuDao
//
//  Created by 汪杰 on 2017/4/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBHPRankListStore.h"
#import "YDListModel.h"

#define     HPRANKLIST_TABLE_NAME             @"homePageRankList"

#define     SQL_CREATE_HPRANKLIST_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
                                                        rank  INTEGER,\
                                                        ub_id INTEGER,\
                                                        ub_nickname TEXT,\
                                                        ub_auth_grade INTEGER,\
                                                        ud_face TEXT,\
                                                        ud_constellation TEXT,\
                                                        PRIMARY KEY(rank))"
#define     SQL_REPLACE_HPRANKLIST           @"REPLACE INTO %@ ( rank, ub_id, ub_nickname, ub_auth_grade, ud_face, ud_constellation) VALUES ( ?, ?, ?, ?, ?, ?)"

#define     SQL_SELECT_ALL_HPRANKLIST        @"SELECT * FROM %@ "

#define     SQL_DELETE_ALL_HPRANKLIST        @"DELETE FROM %@ "

static YDDBHPRankListStore *rankListStore = nil;

@implementation YDDBHPRankListStore

+ (instancetype)shareHPRankListStore{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rankListStore = [[YDDBHPRankListStore alloc] init];
    });
    return rankListStore;
}

- (id)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
        if (![self createTable]) {
            YDLog(@"创建首页排行榜表失败!");
        }else{
            YDLog(@"创建首页排行榜表成功!");
        }
    }
    return self;
}

- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_HPRANKLIST_TABLE,HPRANKLIST_TABLE_NAME];
    return [self createTable:HPRANKLIST_TABLE_NAME withSQL:sqlString];
}

#pragma mark - Public Methods
+ (void)insertRankListData:(NSArray <YDListModel *> *)data{
    [self shareHPRankListStore];
    if (data) {
        [rankListStore deleteAllHPRankListData];
        [data enumerateObjectsUsingBlock:^(YDListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![rankListStore insertSingleHPRankList:obj rank:@(idx)]) {
                YDLog(@"插入首页排行榜数据失败");
            }
        }];
    }
}

+ (NSArray *)selectAllRankListData{
    [self shareHPRankListStore];
    __block NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_ALL_HPRANKLIST,HPRANKLIST_TABLE_NAME];
    [rankListStore excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDListModel *model = [rankListStore createRankListModel:rsSet];
            [data addObject:model];
        }
        [rsSet close];
    }];
    return data;
}

#pragma mark - Private Methods
//删除排行榜所有数据
- (BOOL)deleteAllHPRankListData{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_HPRANKLIST,HPRANKLIST_TABLE_NAME];
    return [rankListStore excuteSQL:sqlString];
}

//插入单条排行榜数据
- (BOOL)insertSingleHPRankList:(YDListModel *)model rank:(NSNumber *)rank{
    NSString *sqlString = [NSString stringWithFormat:SQL_REPLACE_HPRANKLIST,HPRANKLIST_TABLE_NAME];
    NSArray *arrayPara = @[  rank,
                           YDNoNilNumber(model.ub_id),
                           YDNoNilString(model.ub_nickname),
                           YDNoNilNumber(model.ub_auth_grade),
                           YDNoNilString(model.ud_face),
                           YDNoNilString(model.ud_constellation)];
    return [rankListStore excuteSQL:sqlString withArrParameter:arrayPara];
}

//创建排行榜数据模型
- (YDListModel *)createRankListModel:(FMResultSet *)reset{
    YDListModel *model = [[YDListModel alloc] init];
    model.ranking = @([reset intForColumn:@"rank"]);
    model.ub_id = @([reset intForColumn:@"ub_id"]);
    model.ub_nickname = [reset stringForColumn:@"ub_nickname"];
    model.ub_auth_grade = @([reset intForColumn:@"ub_auth_grade"]);
    model.ud_face = [reset stringForColumn:@"ud_face"];
    model.ud_constellation = [reset stringForColumn:@"ud_constellation"];
    return model;
}

@end

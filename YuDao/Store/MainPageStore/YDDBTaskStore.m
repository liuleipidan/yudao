//
//  YDDBTaskStore.m
//  YuDao
//
//  Created by 汪杰 on 2017/4/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBTaskStore.h"
#import "YDTaskModel.h"

#define     TASK_TABLE_NAME             @"tasks"

#define     SQL_CREATE_TASK_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
                                                    tid INTEGER,\
                                                    title TEXT,\
                                                    content TEXT,\
                                                    reward INTEGER,\
                                                    startTime TEXT,\
                                                    endTime TEXT,\
                                                    backgroundImageUrl TEXT,\
                                                    PRIMARY KEY(tid))"
#define     SQL_REPLACE_TASK           @"REPLACE INTO %@ ( tid, title, content, reward, startTime, endTime, backgroundImageUrl) VALUES ( ?, ?, ?, ?, ?, ?, ?)"

#define     SQL_SELECT_ALL_TASKS       @"SELECT * FROM %@ "

#define     SQL_DELETE_ALL_TASKS       @"DELETE FROM %@ "

static YDDBTaskStore *taskStore = nil;

@implementation YDDBTaskStore

+ (instancetype)shareTaskStrore{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        taskStore = [[YDDBTaskStore alloc] init];
    });
    return taskStore;
}

- (id)init{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
        if (![self createTable]) {
            YDLog(@"创建任务表失败!");
        }else{
            YDLog(@"创建任务表成功!");
        }
    }
    return self;
}

- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_TASK_TABLE,TASK_TABLE_NAME];
    return [self createTable:TASK_TABLE_NAME withSQL:sqlString];
}
#pragma mark - Public Methods
+ (void)insertTask:(YDTaskModel *)task{
    if (task == nil) {
        return;
    }
    [self shareTaskStrore];
    if (task) {
        if (![taskStore insertSingleTask:task]) {
            YDLog(@"插入任务失败");
        }
    }
}

+ (void)insertTasks:(NSArray<YDTaskModel *> *)tasks{
    [self shareTaskStrore];
    if (tasks) {
        [taskStore deleteAllTasks];
        [tasks enumerateObjectsUsingBlock:^(YDTaskModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![taskStore insertSingleTask:obj]) {
                YDLog(@"插入任务失败");
            }
        }];
    }
    
}

+ (NSArray *)selectAllTasks{
    [self shareTaskStrore];
    __block NSMutableArray *tasksArr = [NSMutableArray arrayWithCapacity:10];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_ALL_TASKS,TASK_TABLE_NAME];
    [taskStore excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            YDTaskModel *model = [taskStore createTask:rsSet];
            
            [tasksArr addObject:model];
        }
        [rsSet close];
    }];
    
    return tasksArr;
}

//删除所有任务
- (BOOL)deleteAllTasks{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_TASKS,TASK_TABLE_NAME];
    return [taskStore excuteSQL:sqlString];
}

#pragma mark - Private Methods
//插入单条任务
- (BOOL)insertSingleTask:(YDTaskModel *)task{
    
    NSString *sqlString = [NSString stringWithFormat:SQL_REPLACE_TASK,TASK_TABLE_NAME];
    
    NSArray *arrayPara = [NSArray arrayWithObjects:
                          YDNoNilNumber(task.t_id),
                          YDNoNilString(task.t_title),
                          YDNoNilString(task.t_content),
                          YDNoNilNumber(task.t_reward),
                          YDNoNilString(task.t_starttime),
                          YDNoNilString(task.t_endtime),
                          YDNoNilString(task.t_back_ground), nil];
    
    BOOL ok = [taskStore excuteSQL:sqlString withArrParameter:arrayPara];
    return ok;
}
//创建任务数据模型
- (YDTaskModel *)createTask:(FMResultSet *)reset{
    YDTaskModel *task = [[YDTaskModel alloc] init];
    task.t_id = @([reset intForColumn:@"tid"]);
    task.t_title = [reset stringForColumn:@"title"];
    task.t_content = [reset stringForColumn:@"content"];
    task.t_reward = @([reset intForColumn:@"reward"]);
    task.t_starttime = [reset stringForColumn:@"startTime"];
    task.t_endtime = [reset stringForColumn:@"endTime"];
    task.t_back_ground = [reset stringForColumn:@"backgroundImageUrl"];
    
    return task;
}


@end

//
//  YDDBTaskStore.h
//  YuDao
//
//  Created by 汪杰 on 2017/4/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"

/**
 任务数据库操作对象
 */
@interface YDDBTaskStore : YDDBBaseStore

/**
 插入任务数组

 @param tasks 任务数组
 */
+ (void)insertTasks:(NSArray<YDTaskModel *> *)tasks;

/**
 插入单条任务

 @param task 任务
 */
+ (void)insertTask:(YDTaskModel *)task;

/**
 查询所有任务

 @return 所有任务
 */
+ (NSArray *)selectAllTasks;


/**
 删除所有任务

 @return 返回删除成功与否
 */
- (BOOL)deleteAllTasks;

@end

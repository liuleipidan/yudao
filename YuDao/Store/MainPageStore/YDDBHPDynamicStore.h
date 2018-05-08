//
//  YDDBHPDynamicStore.h
//  YuDao
//
//  Created by 汪杰 on 2017/4/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDDynamicModel.h"

@interface YDDBHPDynamicStore : YDDBBaseStore


/**
 插入首页动态数据

 @param data 动态数据
 */
+ (void)insertHPDynamicData:(NSArray <YDDynamicModel *> *)data;


/**
 查询所有首页动态数据

 @return 首页动态数据，默认为最新数据
 */
+ (NSArray *)selectAllHPDynamicData;

- (BOOL)deleteAllHPDynamic;

@end

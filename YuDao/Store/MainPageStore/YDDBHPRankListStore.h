//
//  YDDBHPRankListStore.h
//  YuDao
//
//  Created by 汪杰 on 2017/4/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"

@interface YDDBHPRankListStore : YDDBBaseStore


/**
 插入首页排行榜数据

 @param data 默认为积分排行榜
 */
+ (void)insertRankListData:(NSArray <YDListModel *> *)data;


/**
 查询所有排行榜数据

 @return 排行榜数组，默认为积分排行榜
 */
+ (NSArray *)selectAllRankListData;

@end

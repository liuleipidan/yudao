//
//  YDSingleRankingViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDListModel.h"
#import "YDRankingListModel.h"

@interface YDSingleRankingViewModel : NSObject


@property (nonatomic, strong) NSMutableArray *data;

/**
 当前用户数据
 */
@property (nonatomic, strong) YDRankingListModel *currentUserData;

/**
 当前用户是否在前10,默认为NO
 */
@property (nonatomic, assign) BOOL isTopTen;

/**
 当前排行榜数据类型
 */
@property (nonatomic, assign) YDRankingListDataType dataType;

/**
 筛选条件,初始为-1用以请求第一次的数据
 */
@property (nonatomic, assign) YDRankingListFilterCondition condition;

#pragma mark - 使用此初始化
- (id)initWithDataType:(YDRankingListDataType )dataType;

/**
 请求排行榜数据
 
 @param condition 筛选条件，默认为YDRankingListFilterConditionNo，不限
 @param success 成功
 @param failure 失败
 */
- (void)requestRankingListByFilterCondition:(YDRankingListFilterCondition)condition completion:(void (^)(YDRequestReturnDataType))completion;


+ (NSString *)filterConditionString:(YDRankingListFilterCondition )condition;

+ (NSString *)rankingListDataTypeString:(YDRankingListDataType )dataType;

@end

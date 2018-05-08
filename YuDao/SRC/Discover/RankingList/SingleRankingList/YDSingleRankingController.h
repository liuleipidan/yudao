//
//  YDSingleRankingController.h
//  YuDao
//
//  Created by 汪杰 on 2017/1/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDSingleRankingListCell.h"
#import "YDSingleRankingViewModel.h"

@interface YDSingleRankingController : YDViewController

@property (nonatomic, strong) NSDictionary         *parameters;//初始化请求参数

@property (nonatomic, strong) YDSingleRankingViewModel *viewModel;

#pragma mark - 使用此初始化
- (id)initWitViewModel:(YDSingleRankingViewModel *)viewModel;

/**
 请求排行榜数据

 @param condition 筛选条件，默认不限
 */
- (void)requestRankingListWithCondition:(YDRankingListFilterCondition)condition;


@end

//
//  YDRankListFilterButton.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/26.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDScannerButton.h"

@interface YDRankListFilterButton : YDScannerButton

@property (nonatomic, assign) YDRankingListFilterCondition condition;

- (id)initWithCondition:(YDRankingListFilterCondition)condition title:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath;

@end

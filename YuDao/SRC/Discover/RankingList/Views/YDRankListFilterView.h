//
//  YDRankListFilterView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/26.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YDRankListFilterView : UIView

//最终确认条件
@property (nonatomic, assign) YDRankingListFilterCondition condition;

@property (nonatomic,copy) void (^LFEnsureBlock )(YDRankingListFilterCondition condition);

@end

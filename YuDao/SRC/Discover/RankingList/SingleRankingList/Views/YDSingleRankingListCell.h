//
//  YDSingleRankingListCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTableViewSingleLineCell.h"
#import "YDRankingListModel.h"
#import "YDSingleRLLikeButton.h"

@class YDSingleRankingListCell;
@protocol YDSingleRankingListCellDelegate <NSObject>

- (void)singleRankingListCell:(YDSingleRankingListCell *)cell didClickedLikeButton:(YDSingleRLLikeButton *)likeButton;

@end

@interface YDSingleRankingListCell : YDTableViewSingleLineCell

@property (nonatomic, weak  ) id<YDSingleRankingListCellDelegate> delegate;

@property (nonatomic, strong) YDRankingListModel *item;

@end

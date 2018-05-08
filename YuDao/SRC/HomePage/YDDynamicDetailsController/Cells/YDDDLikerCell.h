//
//  YDDDLikerCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDynamicDetailModel.h"

@class YDDDLikerCell;
@protocol YDDDLikerCellDelegate <NSObject>

- (void)DDlikerCell:(YDDDLikerCell *)cell didClicedAvatarWithIndex:(NSInteger )index;

@optional
- (void)DDlikerCell:(YDDDLikerCell *)cell didSelectedArrowBtn:(UIButton *)arrowBtn;

@end

@interface YDDDLikerCell : UITableViewCell

@property (nonatomic, weak ) id<YDDDLikerCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<YDTapLikeModel *> *likePeople;

@end

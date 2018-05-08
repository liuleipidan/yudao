//
//  YDDDCommentCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTableViewSingleLineCell.h"

#import "YDDynamicDetailModel.h"

@class YDDDCommentCell;
@protocol YDDDCommentCellDelegate <NSObject>

- (void)commentCell:(YDDDCommentCell *)cell didSelectedAvatar:(UIImageView *)avatar;

@end

@interface YDDDCommentCell : YDTableViewSingleLineCell

@property (nonatomic,weak) id<YDDDCommentCellDelegate> delegate;

@property (nonatomic, strong) YDDynamicCommentModel *model;

@end

//
//  LIkedListCell.h
//  YuDao
//
//  Created by 汪杰 on 16/9/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDLikePersonModel.h"

@class YDLikedListCell;

@protocol YDLikedListCellDelegate <NSObject>

- (void)likeListCell:(YDLikedListCell *)cell dataType:(YDLikedPeopleType )dataType;

@end

@interface YDLikedListCell : UITableViewCell

@property (nonatomic, weak) id<YDLikedListCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *headerImageV;//头像
@property (nonatomic, strong) UILabel    *nameLabel;   //名字
@property (nonatomic, strong) UIButton   *addButton;   //添加好友(送礼物)

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) YDLikePersonModel *model;

//数据类型(1 - > 喜欢我的, 2 - > 我喜欢的, 3 - > 互相喜欢的)
@property (nonatomic, assign) YDLikedPeopleType         dataType;

@end

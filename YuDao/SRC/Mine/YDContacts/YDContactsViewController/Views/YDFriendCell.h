//
//  YDFriendCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/29.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDFriendModel.h"

@class YDFriendCell;
@protocol YDFriendCellDelegate <NSObject>

@optional
- (void)friendCell:(YDFriendCell *)cell didClickAvatarImageView:(UIImageView *)avatarImageView;

@end

@interface YDFriendCell : UITableViewCell

//头像
@property (nonatomic, strong) UIImageView *avatarImageView;

//昵称
@property (nonatomic, strong) UILabel *usernameLabel;

//代理
@property (nonatomic, weak  ) id<YDFriendCellDelegate> delegate;

//模型
@property (nonatomic, strong) YDFriendModel *item;

//标记未读数量
- (void)markRemindLabelCount:(NSUInteger)count;

@end

//
//  YDNewFriendCell.h
//  YuDao
//
//  Created by 汪杰 on 17/2/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDNewFriendCell;
@protocol YDNewFriendCellDelegate <NSObject>

- (void)newFriendCell:(YDNewFriendCell *)cell didSelectedBtn:(UIButton *)btn;

@end

@interface YDNewFriendCell : UITableViewCell

@property (nonatomic, weak  ) id<YDNewFriendCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *headerImageV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *acceptBtn;

@property (nonatomic, strong) YDPushMessage *message;

@end

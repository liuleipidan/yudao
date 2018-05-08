//
//  YDDynamicLikerCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/4/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDTapLikeModel;
@interface YDDynamicLikerCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageV;

@property (nonatomic, strong) UILabel    *nameLabel;

@property (nonatomic, strong) UILabel    *timelabel;

@property (nonatomic, strong) YDTapLikeModel *model;

@end

//
//  YDHPMessageBaseCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDHPMessageViewModel.h"

@protocol YDHPMessageCellDelegate <NSObject>

- (void)HPMessageCellMoreButtonClicked:(YDHPMessageModel *)model rect:(CGRect )rect;

@end

@interface YDHPMessageBaseCell : UITableViewCell
{
    UIImageView *_bgImageView;
    UIImageView *_icon;
    UILabel    *_titleLabel;
    UILabel    *_timeLabel;
    UIButton   *_moreBtn;
}

@property (nonatomic,weak) id<YDHPMessageCellDelegate> delegate;

/**
 背景
 */
@property (nonatomic, strong) UIImageView *bgImageView;

/**
 图标
 */
@property (nonatomic, strong) UIImageView *icon;

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 更多（可操作隐藏此模块）
 */
@property (nonatomic, strong) UIButton *moreBtn;

/**
 具体内容,子类视图都添加在这里
 */
@property (nonatomic, strong) UIView *detailContent;

/**
 分割线
 */
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) YDHPMessageModel *model;

@end

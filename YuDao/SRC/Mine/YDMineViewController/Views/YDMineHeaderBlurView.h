//
//  YDMineHeaderBlurView.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDMineHeaderBlurView;
@protocol YDMineHeaderBlurViewDelegate <NSObject>

/**
 点击头像
 */
- (void)mineHeaderBlurView:(YDMineHeaderBlurView *)view clickedUserAvatar:(UIImageView *)imageView;

/**
 点击背景图片
 */
- (void)mineHeaderBlurView:(YDMineHeaderBlurView *)view clickedBackgroundImageView:(UIImageView *)imageView;

/**
 点击二维码
 */
- (void)mineHeaderBlurView:(YDMineHeaderBlurView *)view clickedErCode:(UIImageView *)imageView;

/**
 点击喜欢
 */
- (void)mineHeaderBlurViewClickedLikeLabel:(YDMineHeaderBlurView *)view;

/**
 点击积分
 */
- (void)mineHeaderBlurViewClickedScoreLabel:(YDMineHeaderBlurView *)view;

@end

@interface YDMineHeaderBlurView : UIView

@property (nonatomic, weak  ) id<YDMineHeaderBlurViewDelegate> delegate;

//头像
@property (nonatomic, strong) UIImageView *avatarImageView;

//背景视图
@property (nonatomic, strong) UIImageView *bgImageView;

/**
 用户信息
 */
@property (nonatomic, strong) YDUser *userInfo;

@end

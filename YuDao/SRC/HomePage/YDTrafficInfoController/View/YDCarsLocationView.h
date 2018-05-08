//
//  YDCarsLocationView.h
//  YuDao
//
//  Created by 汪杰 on 16/12/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDTrafficInfoManager.h"

@class YDCarsLocationView;
@protocol YDCarsLocationViewDelegate <NSObject>

- (void)carsLocationView:(YDCarsLocationView *)view didClickedSwitchWithFrame:(CGRect)frame;

/**
 点击排名
 */
- (void)carsLocationViewDidTouchRank;

@optional
- (void)carsLocationView:(YDCarsLocationView *)view didTouchLocationBtn:(UIButton *)locBtn;

@end

@interface YDCarsLocationView : UIView

@property (nonatomic, weak ) id<YDCarsLocationViewDelegate> delegate;

@property (nonatomic, strong) UIButton  *carIcon;

@property (nonatomic, strong) UILabel   *carChooseLabel;

/**
 设置排名和排名图片
 */
- (void)updateRankingByTrafficInfoManager:(YDTrafficInfoManager *)manager;

@end

//
//  YDCarInfoView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDTrafficInfoManager.h"

@protocol YDCarInfoViewDelegate <NSObject>

- (void)carInfoViewClickTest;

- (void)carInfoViewClickMileage;

- (void)carInfoViewClickOilwear;

@end

@interface YDCarInfoView : UIView

@property (nonatomic,weak) id<YDCarInfoViewDelegate> delegate;

- (void)setScore:(NSString *)score;

- (void)updateUIByTrafficInfoManager:(YDTrafficInfoManager *)manager;

- (void)updateDataByTrafficInfoManager:(YDTrafficInfoManager *)manager;

@end

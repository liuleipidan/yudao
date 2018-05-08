//
//  YDTestSwitchCarView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/28.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDTestSwitchCarView : UIView

@property (nonatomic, strong) YDCarDetailModel *selectedCar;

@property (nonatomic, assign, readonly) BOOL isShow;

@property (nonatomic,copy) void (^SCDidSelectedCarBlack )(YDCarDetailModel *selectedCar);

- (void)showInView:(UIView *)view data:(NSArray *)data;

- (void)dismiss;

@end

//
//  YDPresentTransition.h
//  YuDao
//
//  Created by 汪杰 on 16/12/28.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YDPresentTransitionType) {
    YDPresentTransitionTypePresent = 0,//管理present动画
    YDPresentTransitionTypeDismiss//管理dismiss动画
};

@interface YDPresentTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) YDPresentTransitionType type;

//根据定义的枚举初始化的两个方法
+ (instancetype)transitionWithTransitionType:(YDPresentTransitionType)type;
- (instancetype)initWithTransitionType:(YDPresentTransitionType)type;

@end

//
//  XWNaviOneTransition.h
//  trasitionpractice
//
//  Created by YouLoft_MacMini on 15/11/23.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  动画过渡代理管理的是push还是pop
 */
typedef NS_ENUM(NSUInteger, YDNaviTransitionType) {
    YDNaviTransitionTypePush = 0,
    YDNaviTransitionTypePop
};

@interface YDNaviTransition : NSObject<UIViewControllerAnimatedTransitioning>


/**
 *  初始化动画过渡代理
 */
+ (instancetype)transitionWithType:(YDNaviTransitionType)type;
- (instancetype)initWithTransitionType:(YDNaviTransitionType)type;

@end

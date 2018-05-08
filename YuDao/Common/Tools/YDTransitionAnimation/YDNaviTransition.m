//
//  XWNaviOneTransition.m
//  trasitionpractice
//
//  Created by YouLoft_MacMini on 15/11/23.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import "YDNaviTransition.h"


@interface YDNaviTransition ()
/**
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) YDNaviTransitionType type;

@end

@implementation YDNaviTransition

+ (instancetype)transitionWithType:(YDNaviTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(YDNaviTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}
/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return _type == YDNaviTransitionTypePush? 0.4:0.4;
}
/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_type) {
        case YDNaviTransitionTypePush:
            [self doPushAnimation:transitionContext];
            break;
            
        case YDNaviTransitionTypePop:
            [self doPopAnimation:transitionContext];
            break;
    }
    
}

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    YDLog(@"PushAnimation");
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    //toVC.view.alpha = 0;
    toVC.view.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:toVC.view];
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
        toVC.view.alpha = 1;
        toVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
//        
//    } completion:^(BOOL finished) {
//        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
//        
//    }];
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    YDLog(@"PopAnimation");
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView insertSubview:fromVC.view atIndex:0];
    fromVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    fromVC.view.alpha = 1;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        //由于加入了手势必须判断
        [transitionContext completeTransition:YES];
    }];
    
}

@end

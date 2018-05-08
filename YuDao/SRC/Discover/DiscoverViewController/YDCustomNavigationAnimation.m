//
//  YDCustomNavigationAnimation.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/15.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCustomNavigationAnimation.h"

/*
 A          push --->     B
 B           pop --->     A
 ||                      ||
 fromView              toView
 
 谁在转场中主动发起转场，谁就是fromVC、fromView
 A主动push到B，A就是fromVC
 B主动pop 到A，B就是fromVC
 */

@implementation YDCustomNavigationAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    toView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //此处判断是push，还是pop 操作
    BOOL isPush = ([toViewController.navigationController.viewControllers indexOfObject:toViewController] > [fromViewController.navigationController.viewControllers indexOfObject:fromViewController]);
    
    if (isPush) {
        [containerView addSubview:fromView];
        [containerView addSubview:toView];//push,这里的toView 相当于secondVC的view
        toView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }else{
        [containerView addSubview:toView];
        [containerView addSubview:fromView];//pop,这里的fromView 也是相当于secondVC的view
        fromView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    //因为secondVC的view在firstVC的view之上，所以要后添加到containerView中
    
    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (isPush) {
            toView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }else{
            fromView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
    
}

- (void)animationEnded:(BOOL) transitionCompleted{
    NSLog(@"transitionCompleted = %d",transitionCompleted);
}

@end

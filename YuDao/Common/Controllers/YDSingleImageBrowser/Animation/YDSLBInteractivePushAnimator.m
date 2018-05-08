//
//  YDSLBInteractivePushAnimator.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSLBInteractivePushAnimator.h"

@implementation YDSLBInteractivePushAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    
    //From VC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromVC.view;
    [containerView addSubview:fromView];
    
    //To VC
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    //需要先隐藏起来
    toView.hidden = YES;
    [containerView addSubview:toView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [containerView addSubview:bgView];
    
    UIImageView *transitionImgV = [[UIImageView alloc] initWithImage:self.transitionImgV.image];
    transitionImgV.frame = self.transitionBeforeImgFrame;
    [containerView addSubview:transitionImgV];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        transitionImgV.frame = self.transitionAfterImgFrame;
        bgView. alpha = 1;
    } completion:^(BOOL finished) {
        toView.hidden = NO;
        
        [bgView removeFromSuperview];
        [transitionImgV removeFromSuperview];
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
        
    }];
    
}

@end

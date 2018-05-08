//
//  YDSLBInteractivePopAnimator.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSLBInteractivePopAnimator.h"

@implementation YDSLBInteractivePopAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    
    //To VC
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    [containerView addSubview:toView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 1;
    [containerView addSubview:bgView];
    
    UIImageView *transitionImgV = [[UIImageView alloc] initWithImage:self.transitionImgV.image];
    transitionImgV.frame = self.transitionAfterImgFrame;
    [containerView addSubview:transitionImgV];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        transitionImgV.frame = self.transitionBeforeImgFrame;
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [transitionImgV removeFromSuperview];
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    
}

@end

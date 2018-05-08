//
//  YDPictureBrowsePopAnimator.m
//  YDCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "YDPictureBrowsePopAnimator.h"
#import "YDPictureBrowseTransitionParameter.h"

@interface YDPictureBrowsePopAnimator ()

@end

@implementation YDPictureBrowsePopAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    //FromVC
    //UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect fromFrame = self.transitionParameter.secondVCImgFrame;
    CGRect toFrame = [self.transitionParameter.firstVCImgFrames[self.transitionParameter.transitionImgIndex] CGRectValue];
    
    //有渐变的黑色背景
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 1;
    [containerView addSubview:bgView];
    
    //过渡的图片
    UIView *transitionImgView = [[UIImageView alloc] initWithImage:self.transitionParameter.transitionImage];
    transitionImgView.clipsToBounds = YES;
    transitionImgView.frame = fromFrame;
    [containerView addSubview:transitionImgView];
    
    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //避免frame数值都为零的处理
        CGRect imageFrame = toFrame;
        if (imageFrame.size.width == 0 && imageFrame.size.height == 0) {
            CGFloat defaultWidth = 5;
            imageFrame = CGRectMake((SCREEN_WIDTH - defaultWidth) * 0.5, (SCREEN_HEIGHT - defaultWidth) * 0.5, defaultWidth, defaultWidth);
        }
        
        transitionImgView.frame = imageFrame;
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end


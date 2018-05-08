//
//  YDSLBInteractiveTransition.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSLBInteractiveTransition.h"
#import "YDSLBInteractivePushAnimator.h"
#import "YDSLBInteractivePopAnimator.h"
#import "YDSLBPercentDrivenInteractive.h"

@interface YDSLBInteractiveTransition()

@property (nonatomic, strong) YDSLBInteractivePushAnimator *pushAnimator;

@property (nonatomic, strong) YDSLBInteractivePopAnimator *popAnimator;

@property (nonatomic, strong) YDSLBPercentDrivenInteractive *percentInteractive;

@end

@implementation YDSLBInteractiveTransition

#pragma mark - Public Methods
- (void)setTransitionImgV:(UIImageView *)transitoinImgV{
    self.pushAnimator.transitionImgV = transitoinImgV;
    self.popAnimator.transitionImgV = transitoinImgV;
}

- (void)setTransitionBeforeImgFrame:(CGRect)frame{
    self.pushAnimator.transitionBeforeImgFrame = frame;
    self.popAnimator.transitionBeforeImgFrame = frame;
    self.percentInteractive.beforeImgVFrame = frame;
}

- (void)setTransitionAfterImgFrame:(CGRect)frame{
    self.pushAnimator.transitionAfterImgFrame = frame;
    self.popAnimator.transitionAfterImgFrame = frame;
}

#pragma mark - Setters
- (void)setBeforeImgFrame:(CGRect)beforeImgFrame{
    _beforeImgFrame = beforeImgFrame;
    self.percentInteractive.beforeImgVFrame = beforeImgFrame;
}

- (void)setCurrentImgVFrame:(CGRect)currentImgVFrame{
    _currentImgVFrame = currentImgVFrame;
    self.percentInteractive.currentImgVFrame = currentImgVFrame;
}

- (void)setCurrentImgV:(UIImageView *)currentImgV{
    _currentImgV = currentImgV;
    self.percentInteractive.currentImgV = currentImgV;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.pushAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.popAnimator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (self.gestrueRecognizer) {
        return self.percentInteractive;
    }
    return nil;
}

- (YDSLBInteractivePushAnimator *)pushAnimator{
    if (_pushAnimator == nil) {
        _pushAnimator = [YDSLBInteractivePushAnimator new];
    }
    return _pushAnimator;
}

- (YDSLBInteractivePopAnimator *)popAnimator{
    if (_popAnimator == nil) {
        _popAnimator = [YDSLBInteractivePopAnimator new];
    }
    return _popAnimator;
}

- (YDSLBPercentDrivenInteractive *)percentInteractive{
    if (_percentInteractive == nil) {
        _percentInteractive = [[YDSLBPercentDrivenInteractive alloc] initWithGestureRecognizer:self.gestrueRecognizer];
    }
    return _percentInteractive;
}

@end

//
//  YDPictureBrowseInteractiveAnimatedTransition.m
//  YDCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "YDPictureBrowseInteractiveAnimatedTransition.h"
#import "YDPictureBrowsePercentDrivenInteractive.h"
#import "YDPictureBrowsePushAnimator.h"
#import "YDPictureBrowsePopAnimator.h"

@interface YDPictureBrowseInteractiveAnimatedTransition ()

@property (nonatomic, strong) YDPictureBrowsePushAnimator *customPush;
@property (nonatomic, strong) YDPictureBrowsePopAnimator  *customPop;
@property (nonatomic, strong) YDPictureBrowsePercentDrivenInteractive *percentIntractive;

@end

@implementation YDPictureBrowseInteractiveAnimatedTransition

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.customPush;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.customPop;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    
    return nil;//push时不加手势交互
}
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (self.transitionParameter.gestureRecognizer)
        return self.percentIntractive;
    else
        return nil;
    
}

-(YDPictureBrowsePushAnimator *)customPush
{
    if (_customPush == nil) {
        _customPush = [[YDPictureBrowsePushAnimator alloc]init];
    }
    return _customPush;
}

- (YDPictureBrowsePopAnimator *)customPop {
    if (!_customPop) {
        _customPop = [[YDPictureBrowsePopAnimator alloc] init];
    }
    return _customPop;
}
- (YDPictureBrowsePercentDrivenInteractive *)percentIntractive{
    if (!_percentIntractive) {
        _percentIntractive = [[YDPictureBrowsePercentDrivenInteractive alloc] initWithTransitionParameter:self.transitionParameter];
    }
    return _percentIntractive;
}

-(void)setTransitionParameter:(YDPictureBrowseTransitionParameter *)transitionParameter{
    _transitionParameter = transitionParameter;
    
    self.customPush.transitionParameter = transitionParameter;
    self.customPop.transitionParameter = transitionParameter;
}

@end



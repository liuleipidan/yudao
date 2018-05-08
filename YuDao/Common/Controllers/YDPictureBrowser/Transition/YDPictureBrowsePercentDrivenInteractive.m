//
//  YDPictureBrowsePercentDrivenInteractive.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPictureBrowsePercentDrivenInteractive.h"
#import "YDPictureBrowseTransitionParameter.h"

@interface YDPictureBrowsePercentDrivenInteractive ()

@property (nonatomic, strong) YDPictureBrowseTransitionParameter *transitionParameter;

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *gestureRecognizer;

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIView *fromView;

@property(nonatomic, strong) UIView *blackBgView;

@end

@implementation YDPictureBrowsePercentDrivenInteractive

- (void)dealloc
{
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (instancetype)initWithTransitionParameter:(YDPictureBrowseTransitionParameter *)transitionParameter{
    
    self = [super init];
    if (self)
    {
        _transitionParameter = transitionParameter;
        _gestureRecognizer = transitionParameter.gestureRecognizer;
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    
    CGFloat scale = 1 - (translation.y / SCREEN_HEIGHT);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    return scale;
}

- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat scrale = [self percentForGesture:gestureRecognizer];
    
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            [self updateInterPercent:[self percentForGesture:gestureRecognizer]];
            
            break;
        case UIGestureRecognizerStateEnded:
            
            if (scrale > 0.95f){
                
                [self cancelInteractiveTransition];
                [self interPercentCancel];
            }
            else{
                [self finishInteractiveTransition];
                [self interPercentFinish:scrale];
            }
            break;
        default:
            [self cancelInteractiveTransition];
            [self interPercentCancel];
            break;
    }
}

- (void)beginInterPercent{
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //有渐变的黑色背景
    _blackBgView = [[UIView alloc] initWithFrame:containerView.bounds];
    _blackBgView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:_blackBgView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:fromView];
}

- (void)updateInterPercent:(CGFloat)scale{
//        NSLog(@"变化");
    
    _blackBgView.alpha = scale * scale * scale;
}

- (void)interPercentCancel{
    NSLog(@"取消");
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:fromView];
    
    [_blackBgView removeFromSuperview];
    _blackBgView = nil;
    
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}
//完成
- (void)interPercentFinish:(CGFloat)scale{
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //有渐变的黑色背景
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = scale * scale * scale;
    [containerView addSubview:bgView];
    
    //过渡的图片
    UIImageView *transitionImgView = [[UIImageView alloc] initWithImage:self.transitionParameter.transitionImage];
    transitionImgView.clipsToBounds = YES;
    transitionImgView.frame = self.transitionParameter.currentPanGestImgFrame;
    [containerView addSubview:transitionImgView];
    
    [UIView animateWithDuration:0.4 animations:^{
        transitionImgView.frame = self.transitionParameter.firstVCImgFrame;
        bgView.alpha = 0;
        //_blackBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [_blackBgView removeFromSuperview];
        _blackBgView = nil;
        
        [bgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    //弹簧效果
//    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
//
//        transitionImgView.frame = self.transitionParameter.firstVCImgFrame;
//        bgView.alpha = 0;
//
//    }completion:^(BOOL finished) {
//
//        [_blackBgView removeFromSuperview];
//        [_firstVCImgWhiteView removeFromSuperview];
//        _blackBgView = nil;
//        _firstVCImgWhiteView = nil;
//
//        [bgView removeFromSuperview];
//        [imgBgWhiteView removeFromSuperview];
//        [transitionImgView removeFromSuperview];
//
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    [self beginInterPercent];
}

@end


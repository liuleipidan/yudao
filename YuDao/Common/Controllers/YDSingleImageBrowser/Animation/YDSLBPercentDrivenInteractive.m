//
//  YDSLBPercentDrivenInteractive.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSLBPercentDrivenInteractive.h"

@interface YDSLBPercentDrivenInteractive()

@property (nonatomic, weak  ) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *fromView;

@property (nonatomic, strong) UIView *beforeImgV;

@property (nonatomic, strong) UIView *blackBgView;

@end


@implementation YDSLBPercentDrivenInteractive

- (id)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer{
    if (self = [super init]) {
        _gestureRecognizer = gestureRecognizer;
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdater:)];
    }
    return self;
}

- (void)dealloc
{
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdater:)];
}


- (CGFloat)percentForGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    
    CGFloat scale = 1 - (translation.y / SCREEN_HEIGHT);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    return scale;
}

- (void)gestureRecognizeDidUpdater:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat scale = [self percentForGestureRecognizer:gestureRecognizer];
    //NSLog(@"scale = %f",scale);
    //YDPanGestureRecognizerMoveDirection direction = [gestureRecognizer yd_determineCameraDirectionIfNeeded:[gestureRecognizer translationInView:gestureRecognizer.view]];
    
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            //没用
            break;
        case UIGestureRecognizerStateChanged:
        {
//            if (direction != YDPanGestureRecognizerMoveDirectionDown) {
//                [gestureRecognizer cancelsTouchesInView];
//                return;
//            }
            [self updateInteractiveTransition:[self percentForGestureRecognizer:gestureRecognizer]];
            [self updateInterPercent:[self percentForGestureRecognizer:gestureRecognizer]];
            
            break;}
        case UIGestureRecognizerStateEnded:
        {
//            if (direction != YDPanGestureRecognizerMoveDirectionDown) {
//                [gestureRecognizer cancelsTouchesInView];
//                [self cancelInteractiveTransition];
//                [self interPercentCancel];
//                return;
//            }
            if (scale > 0.7f){
                [self cancelInteractiveTransition];
                [self interPercentCancel];
            }
            else{
                [self finishInteractiveTransition];
                [self interPercentFinish:scale];
            }
            break;}
        case UIGestureRecognizerStateCancelled:
        {
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;}
        default:
            [self cancelInteractiveTransition];
            [self interPercentCancel];
            break;
    }
}

- (void)beginInterPercent{
    //    NSLog(@"开始");
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //图片背景白色的空白view
    
    _beforeImgV = [[UIView alloc] initWithFrame:self.beforeImgVFrame];
    _beforeImgV.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:_beforeImgV];
    
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
    //    NSLog(@"变化");
    
    _blackBgView.alpha = scale * scale * scale;
}

- (void)interPercentCancel{
    //    NSLog(@"取消");
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:fromView];
    
    [_blackBgView removeFromSuperview];
    [_beforeImgV removeFromSuperview];
    _blackBgView = nil;
    _beforeImgV = nil;
    
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}
//完成
- (void)interPercentFinish:(CGFloat)scale{
    //    NSLog(@"完成");
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //图片背景白色的空白view
    UIView *imgBgWhiteView = [[UIView alloc] initWithFrame:self.beforeImgVFrame];
    imgBgWhiteView.backgroundColor =[UIColor whiteColor];
    [containerView addSubview:imgBgWhiteView];
    
    //有渐变的黑色背景
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = scale;
    [containerView addSubview:bgView];
    
    //过渡的图片
    UIImageView *transitionImgView = [[UIImageView alloc] initWithImage:self.currentImgV.image];
    transitionImgView.clipsToBounds = YES;
    transitionImgView.frame = self.currentImgVFrame;
    [containerView addSubview:transitionImgView];
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        transitionImgView.frame = self.beforeImgVFrame;
        bgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        NSLog(@"panGesture animation finished");
        
        [_blackBgView removeFromSuperview];
        [_beforeImgV removeFromSuperview];
        _blackBgView = nil;
        _beforeImgV = nil;
        
        [bgView removeFromSuperview];
        [imgBgWhiteView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}


- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //[super startInteractiveTransition:transitionContext];
    self.transitionContext = transitionContext;
    
    [self beginInterPercent];
}

@end

//
//  YDSingleImageBrowserController.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSingleImageBrowserController.h"
#import "YDSLBInteractiveTransition.h"

@interface YDSingleImageBrowserController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) YDSLBInteractiveTransition *animatedTransition;

@property (nonatomic, assign) CGPoint transitionImgVCenter;

@property (nonatomic, assign) CGRect beforeImgVFrame;

@end

@implementation YDSingleImageBrowserController

- (id)initWithImage:(UIImage *)image{
    if (self = [super init]) {
        
        self.imageView.image = image;
    }
    return self;
}

- (id)initWithImageView:(UIImageView *)imageView{
    if (self = [super init]) {
        
        _beforeImgVFrame = [imageView.superview convertRect:imageView.frame toView:nil];
        self.imageView.image = imageView.image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGSize imageSize = [UIImage yd_getAdaptedSize:self.imageView.image width:SCREEN_WIDTH];
    [self.imageView setFrame:CGRectMake(0, (SCREEN_HEIGHT-imageSize.width)/2.0, SCREEN_WIDTH, imageSize.height)];
    [self.view addSubview:self.imageView];
    
    _transitionImgVCenter = self.imageView.center;
    
    //点击手势
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slb_tapScreen:)]];
    
    
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - Events
- (void)slb_tapScreen:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)slb_panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    CGPoint translation = [pan translationInView:pan.view];
    //YDPanGestureRecognizerMoveDirection direction = [pan yd_determineCameraDirectionIfNeeded:translation];
    
    CGFloat scale = 1 - (translation.y / SCREEN_HEIGHT);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    switch (pan.state) {
        case UIGestureRecognizerStatePossible:
            
            break;
        case UIGestureRecognizerStateBegan:
        {
            _transitionImgVCenter = self.imageView.center;
            
            //设置代理
            self.animatedTransition = nil;
            self.transitioningDelegate = self.animatedTransition;
            
            //传入手势
            self.animatedTransition.gestrueRecognizer = pan;
            
            //dismiss
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;}
            
        case UIGestureRecognizerStateChanged:
        {
//            if (direction != YDPanGestureRecognizerMoveDirectionDown) {
//
//                return;
//            }
            CGPoint center = CGPointMake(_transitionImgVCenter.x + translation.x * scale, _transitionImgVCenter.y + translation.y);
            _imageView.center = center;
            _imageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            self.animatedTransition.beforeImgFrame = self.beforeImgVFrame;
            
            break;}
            
        case UIGestureRecognizerStateEnded:
        {
            if (scale > 0.7) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.imageView.center  = self.transitionImgVCenter;
                    self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    self.imageView.transform = CGAffineTransformIdentity;
                }];
            }
            
            self.animatedTransition.currentImgV = self.imageView;
            self.animatedTransition.currentImgVFrame = self.imageView.frame;
            self.animatedTransition.gestrueRecognizer = nil;
            
            break;}
            
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
            
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Getter
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slb_panGestureRecognizer:)];
        [_imageView addGestureRecognizer:pan];
        
    }
    return _imageView;
}

- (YDSLBInteractiveTransition *)animatedTransition{
    if (_animatedTransition == nil) {
        _animatedTransition = [YDSLBInteractiveTransition new];
    }
    return _animatedTransition;
}



@end

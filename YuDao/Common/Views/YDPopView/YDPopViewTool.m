//
//  YDPopViewTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPopViewTool.h"
#import "FXBlurView.h"
#import <POP.h>

#define kSpringAnimationName @"kSpringAnimationName"

@interface YDPopViewTool()

/**
 显示窗口
 */
@property (nonatomic, strong) UIWindow *window;

/**
 用于暂存原来的主窗口
 */
@property (nonatomic, strong) UIWindow *oldWindow;

/**
 背景图片
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 模糊视图
 */
@property (nonatomic, strong) FXBlurView *blurView;

/**
 内容视图
 */
@property (nonatomic, strong) UIView *contentView;

/**
 正在动画
 */
@property (nonatomic, assign) BOOL isAnimation;

/**
 是否正在展示
 */
@property (nonatomic, assign) BOOL isShow;

@end

static YDPopViewTool *popViewTool = nil;

@implementation YDPopViewTool

- (instancetype)init{
    if (self = [super init]) {
        [self.window addSubview:self.backgroundImageView];
        [self.window addSubview:self.blurView];
        [self.window addSubview:self.contentView];
    }
    return self;
}

#pragma mark - Public Methods
+ (void)showWithContentView:(UIView *)contentView{
    popViewTool = [[YDPopViewTool alloc] init];
    [popViewTool setup];
    [popViewTool.contentView addSubview:contentView];
    [contentView layoutIfNeeded];
    contentView.center = popViewTool.contentView.center;
    popViewTool.window.alpha = 0;
    popViewTool.isAnimation = YES;
    [UIView animateWithDuration:0.2 animations:^{
        popViewTool.window.alpha = 1;
    } completion:^(BOOL finished) {
        popViewTool.isAnimation = NO;
    }];
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
//    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(contentView.frame.size.width * 0.9, contentView.frame.size.height * 0.9)];
//    scaleAnimation.toValue = [NSValue valueWithCGSize:contentView.frame.size];
//    scaleAnimation.springBounciness = 10.f;
//    scaleAnimation.beginTime = CACurrentMediaTime();
//    scaleAnimation.removedOnCompletion = YES;
//    [scaleAnimation setCompletionBlock:^(POPAnimation *animation,BOOL finished){
//        popViewTool.isAnimation = YES;
//    }];
//    [contentView.layer pop_addAnimation:scaleAnimation forKey:kSpringAnimationName];
}

+ (void)dismissView{
    if (popViewTool.isShow) {
        popViewTool.isShow = NO;
        [popViewTool dismiss];
    }
}

#pragma mark - Private Methods
/**
 初始化
 */
- (void)setup{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow != _oldWindow) {
        //暂存主窗口
        self.oldWindow = keyWindow;
    }
    [self.window makeKeyAndVisible];
    self.isShow = YES;
}
/**
 点击背景视图，dismiss
 */
- (void)touchBackgroundView:(UITapGestureRecognizer *)tap{
    if (self.isAnimation) {
        return;
    }
    CGPoint point = [tap locationInView:tap.view];
    if (tap.view.subviews.count > 0) {
        UIView *view = tap.view.subviews.firstObject;
        CGFloat x1 = view.x;
        CGFloat x2 = view.x + view.width;
        CGFloat y1 = view.y;
        CGFloat y2 = view.y + view.height;
        if (!(point.x >= x1 && point.x <= x2 && point.y >= y1 && point.y <= y2)) {
            [self dismiss];
        }
    }else{
        [self dismiss];
    }
}
/**
 隐藏window
 */
- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeViews];
    }];
}
/**
 移除widow和其所有子视图
 */
- (void)removeViews{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView removeFromSuperview];
    [self.blurView removeFromSuperview];
    self.contentView = nil;
    self.blurView = nil;
    [self.window resignKeyWindow];
    self.window.hidden = YES;
    [self.oldWindow makeKeyAndVisible];
    self.window = nil;
    popViewTool = nil;
}

#pragma mark - Getters
- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelStatusBar - 1;
    }
    return _window;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBackgroundView:)]];
    }
    return _contentView;
}

- (FXBlurView *)blurView{
    if (!_blurView) {
        _blurView = [FXBlurView new];
        _blurView.tintColor = nil;
        _blurView.blurRadius = 20.0;
        _blurView.frame = [UIScreen mainScreen].bounds;
    }
    return _blurView;
}

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        UIImage *image = [UIImage fullScreenshots];
        _backgroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundImageView.image = image;
    }
    return _backgroundImageView;
}


@end

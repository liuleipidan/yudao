//
//  YDPopBlurViewManager.m
//  YuDao
//
//  Created by 汪杰 on 17/3/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPopBlurViewManager.h"
#import "FXBlurView.h"

static YDPopBlurViewManager *_manager = nil;
@interface YDPopBlurViewManager()

@property (nonatomic, weak) UIWindow *window;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) FXBlurView *blurView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, assign) YDPopBlurType type;

@end

@implementation YDPopBlurViewManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}



+ (void)showWithContentView:(UIView *)contentView
                  blurAlpha:(NSNumber *)alpha
                   withType:(YDPopBlurType )type;{
    _manager = [[YDPopBlurViewManager alloc] init];
    _manager.type = type;
    _manager.window = [UIApplication sharedApplication].keyWindow;
    [_manager.window addSubview:_manager.effectView];
    if (contentView) {
        _manager.contentView = contentView;
        _manager.oldFrame = contentView.frame;
        [_manager.window addSubview:contentView];
    }
    _manager.effectView.alpha = 0;
    
    if (type == YDPopBlurTypeDefault) {
        _manager.effectView.contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [UIView animateWithDuration:0.25 animations:^{
            _manager.effectView.alpha = alpha?alpha.floatValue:1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
    if (type == YDPopBlurTypeSpring) {
        [UIView animateWithDuration:0.25 animations:^{
            _manager.effectView.alpha = alpha?alpha.floatValue:1.0;
            contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            contentView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

+ (instancetype)showBlurViewWithContentView:(UIView *)contentView
                                  initFrame:(CGRect )initFrame
                                  blurAlpha:(CGFloat )alpha
                                       type:(YDPopBlurType)type{
    _manager = [[YDPopBlurViewManager alloc] init];
    _manager.type = type;
    _manager.window = [UIApplication sharedApplication].keyWindow;
    _manager.blurView.blurRadius = alpha;
    [_manager.window addSubview:_manager.blurView];
    if (contentView) {
        _manager.contentView = contentView;
        _manager.oldFrame = initFrame;
        [_manager.window addSubview:contentView];
    }
    if (type == YDPopBlurTypeSpring) {
        [UIView animateWithDuration:0.25 animations:^{
            contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            contentView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    return _manager;
}

+ (void)showWithContentView:(UIView *)contentView
                  fromFrame:(CGRect )frame
                  blurAlpha:(NSNumber *)alpha
                   withType:(YDPopBlurType)type{
    _manager = [[YDPopBlurViewManager alloc] init];
    _manager.type = type;
    _manager.window = [UIApplication sharedApplication].keyWindow;
    [_manager.window addSubview:_manager.effectView];
    if (contentView) {
        _manager.contentView = contentView;
        _manager.oldFrame = frame;
        [_manager.window addSubview:contentView];
    }
    _manager.effectView.alpha = 0;
    _manager.contentView.alpha = 0;
    if (type == YDPopBlurTypeDefault) {
        _manager.effectView.contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [UIView animateWithDuration:0.25 animations:^{
            _manager.effectView.alpha = alpha?alpha.floatValue:1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
    if (type == YDPopBlurTypeSpring) {
        [UIView animateWithDuration:0.25 animations:^{
            _manager.effectView.alpha = alpha?alpha.floatValue:1.0;
            _manager.contentView.alpha = 1;
            contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            contentView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

#pragma mark Events
- (void)tapBackgroundBlurView:(UITapGestureRecognizer *)tap{
    [_manager dismiss];
}

+ (void)dismiss{
    [_manager dismiss];
}

- (void)dismiss{
    if (_manager.type == YDPopBlurTypeDefault) {
        [UIView animateWithDuration:0.25 animations:^{
            _manager.effectView.alpha = 0;
        } completion:^(BOOL finished) {
            [_manager.contentView removeFromSuperview];
            _manager.contentView = nil;
            _manager.oldFrame = CGRectZero;
            [_manager.effectView removeFromSuperview];
            _manager.window = nil;
            _manager = nil;
        }];
    }
    if (_manager.type == YDPopBlurTypeSpring) {
        [UIView animateWithDuration:0.25 animations:^{
            _manager.contentView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            _manager.contentView.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateWithDuration:0.25 animations:^{
                _manager.blurView.alpha = 0;
                _manager.contentView.alpha = 0;
                _manager.contentView.frame = _manager.oldFrame;
            } completion:^(BOOL finished) {
                [_manager.contentView removeFromSuperview];
                
                _manager.contentView = nil;
                _manager.oldFrame = CGRectZero;
                [_manager.blurView removeFromSuperview];
                [_manager.effectView removeFromSuperview];
                _manager.window = nil;
                _manager = nil;
            }];
        }];
    }
}

#pragma mark Getters
- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.frame = [UIScreen mainScreen].bounds;
        _effectView.contentView.frame = [UIScreen mainScreen].bounds;
        _effectView.contentView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundBlurView:)];
        [_effectView addGestureRecognizer:tap];
    }
    return _effectView;
}

- (FXBlurView *)blurView{
    if (!_blurView) {
        _blurView = [FXBlurView new];
        _blurView.tintColor = nil;
        _blurView.blurRadius = 20.0;
        _blurView.frame = [UIScreen mainScreen].bounds;
        [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundBlurView:)]];
    }
    return _blurView;
}

@end

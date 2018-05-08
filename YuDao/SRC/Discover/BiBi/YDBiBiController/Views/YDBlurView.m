//
//  YDBlurView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/5.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBlurView.h"
#import "FXBlurView.h"

@interface YDBlurView()

@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, strong) FXBlurView *blurView;

@end

@implementation YDBlurView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideAction:)];
    [self addGestureRecognizer:tap];
    
    _blurView = [[FXBlurView alloc] init];
    _blurView.blurRadius = 10;
    //_blurView.backgroundColor = [UIColor whiteColor];
    _blurView.tintColor = nil;
    [self addSubview:_blurView];
    [_blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

}

- (void)tapHideAction:(UIGestureRecognizer *)ges{
    [self hideWithAnimated:YES];
}

- (void)hideWithAnimated:(BOOL )animated{
    NSTimeInterval time = animated ? 0.5 : 0;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Public Methods
- (void)showInView:(UIView *)view
          animated:(BOOL)animated{
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    self.alpha = 0;
    NSTimeInterval time = animated ? 1 : 0;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setBlurRadius:(CGFloat)radius{
    _blurView.blurRadius = radius;
}

- (void)setBgImage:(UIImage *)bgImage{
    _bgImage = bgImage;
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:bgImage];
        [self insertSubview:_bgImgV belowSubview:_blurView];
    }
    [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end

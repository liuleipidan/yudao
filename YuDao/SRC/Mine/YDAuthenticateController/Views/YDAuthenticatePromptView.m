//
//  YDAuthenticatePromptView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAuthenticatePromptView.h"

static const NSTimeInterval authenicateShowTime = 0.2;

@interface YDAuthenticatePromptView()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation YDAuthenticatePromptView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.alpha = 0;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        
        [self addSubview:self.backgroundView];
        
        [self addSubview:self.imageView];
        
        [self.imageView addSubview:self.cancelBtn];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.top.equalTo(_imageView).offset(20);
            make.right.equalTo(_imageView).offset(-20);
        }];
    }
    return self;
}

#pragma mark - Public Methods
+ (void)showWithImage:(UIImage *)image{
    YDAuthenticatePromptView *view = [[YDAuthenticatePromptView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [view.imageView setImage:image];
    [view.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(315), kHeight(379)));
    }];
    
    [view show];
}

#pragma mark - Private Methods
- (void)show{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:authenicateShowTime animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:authenicateShowTime animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)tapImageViewAction:(UIGestureRecognizer *)tap{
    
}

#pragma mark - Getter

- (UIView *)backgroundView{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = YDColor(0, 0, 0, 1);
        _backgroundView.alpha = 0.4f;
    }
    return _backgroundView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.layer.cornerRadius = 8.0f;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction:)]];
    }
    return _imageView;
}

- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setBackgroundImage:YDImage(@"mine_auth_pop_cancel") forState:0];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end

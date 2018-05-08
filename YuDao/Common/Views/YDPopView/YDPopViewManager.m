//
//  YDPopViewManager.m
//  YuDao
//
//  Created by 汪杰 on 17/3/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPopViewManager.h"

@interface YDPopViewManager()

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, weak  ) UIWindow *oldWindow;

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *oneBtn;
@property (nonatomic, strong) UIButton *twoBtn;

@property (nonatomic, strong) UIImageView *lefImageV;
@property (nonatomic, strong) UIImageView *rightImageV;

@property (nonatomic, strong) UILabel  *promptLabel;

@property (nonatomic, copy) void (^selectedBlock) (NSInteger index);

@end

static YDPopViewManager *popM = nil;
static dispatch_once_t onceToken;

@implementation YDPopViewManager

+ (YDPopViewManager *)shareIntance{
    
    dispatch_once(&onceToken, ^{
        popM = [[YDPopViewManager alloc] init];
    });
    return popM;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.window addSubview:self.coverView];
        [self.window addSubview:self.effectView];
        [self.window addSubview:self.contentView];
        
        [self y_layoutSubviews];
    }
    return self;
}

+ (void)attemptDealloc{
    onceToken = 0;
    popM = nil;
}

- (void)y_layoutSubviews{
    
    CGFloat width = kWidth((309));
    CGFloat height = kHeight((44));
    _twoBtn.frame = CGRectMake(-width, SCREEN_HEIGHT-20-height, width, height);
    _oneBtn.frame = CGRectMake(SCREEN_WIDTH+width, _twoBtn.y-height-10, width, height);
}

- (void)showPopViewWithUserName:(NSString *)name
                   leftImageUrl:(NSString *)leftImageUrl
                  rightImageUrl:(NSString *)rightImageUrl
                  selectedBlock:(void (^)(NSInteger index))selectedBlock{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow != _oldWindow) {
        _oldWindow = keyWindow;
    }
    _selectedBlock = selectedBlock;
    _promptLabel.text = [NSString stringWithFormat:@"你与%@相互喜欢了对方",name];
    [self.window makeKeyAndVisible];
    [self.coverView yd_setImageWithString:leftImageUrl showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.coverView yd_setImageWithString:leftImageUrl placeholaderImageString:kDefaultAvatarPath showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_lefImageV yd_setImageWithString:leftImageUrl placeholaderImageString:kDefaultAvatarPath showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_rightImageV yd_setImageWithString:rightImageUrl placeholaderImageString:kDefaultAvatarPath showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    _effectView.alpha = 0;
    _coverView.alpha = 0;
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        _effectView.alpha = 1;
        _coverView.alpha = 1;
        _contentView.alpha = 1;
        _twoBtn.x = (SCREEN_WIDTH-kWidth(309))/2;
        _oneBtn.x = (SCREEN_WIDTH-kWidth(309))/2;
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - Button Action
- (void)buttonAction:(UIButton *)button{
    
    [self dismissWithIndex:button.tag-1000];
}

#pragma mark dismiss
- (void)dismissWithIndex:(NSInteger )index{
    [UIView animateWithDuration:0.2 animations:^{
        _twoBtn.x = -kWidth(309);
        _oneBtn.x = SCREEN_WIDTH+kWidth(309);
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _effectView.alpha = 0;
            _coverView.alpha = 0;
        } completion:^(BOOL finished) {
            if (_selectedBlock) {
                _selectedBlock(index);
                _selectedBlock = nil;
            }
            [_window resignKeyWindow];
            _window.hidden = YES;
            [_oldWindow makeKeyAndVisible];
            _oldWindow = nil;
            
        }];
    }];
    
}

- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelStatusBar - 1;
    }
    return _window;
}

- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.userInteractionEnabled = YES;
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.clipsToBounds = YES;
        
    }
    return _coverView;
}

- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.frame = [UIScreen mainScreen].bounds;
    }
    return _effectView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneBtn setTitle:@"查看资料" forState:0];
        [_oneBtn setBackgroundColor:YDBaseColor];
        [_oneBtn.layer setCornerRadius:8.0f];
        [_oneBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _oneBtn.tag = 1001;
        _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoBtn setTitle:@"继续探索" forState:0];
        [_twoBtn.layer setCornerRadius:8.0f];
        [_twoBtn.layer setBorderColor:YDBaseColor.CGColor];
        [_twoBtn.layer setBorderWidth:1.0f];
        [_twoBtn setTitleColor:YDBaseColor forState:0];
        _twoBtn.tag = 1002;
        [_twoBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_slipFace_congratulations"]];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.frame = CGRectMake(10, 72, SCREEN_WIDTH-20, 56);
        
        
        _promptLabel = [YDUIKit labelTextColor:[UIColor whiteColor] fontSize:16 textAlignment:NSTextAlignmentCenter];
        _promptLabel.frame = CGRectMake(0, CGRectGetMaxY(imageV.frame)+15, SCREEN_WIDTH, 21);
        
        _lefImageV = [[UIImageView alloc] init];
        
        _lefImageV.frame = CGRectMake(kWidth(30), (SCREEN_HEIGHT-kHeight(200))/2, kWidth(150), kHeight(200));
        _lefImageV.backgroundColor = [UIColor blackColor];
        _lefImageV.transform = CGAffineTransformMakeRotation(-M_PI/18);
        _lefImageV.layer.cornerRadius = 8.0f;
        _lefImageV.contentMode = UIViewContentModeScaleAspectFill;
        _lefImageV.clipsToBounds = YES;
        _lefImageV.layer.borderWidth = 3.0f;
        _lefImageV.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        _rightImageV = [[UIImageView alloc] init];
        _rightImageV.frame = CGRectMake(SCREEN_WIDTH-kWidth(150)-kWidth(30), (SCREEN_HEIGHT-kHeight(200))/2, kWidth(150), kHeight(200));
        _rightImageV.backgroundColor = [UIColor redColor];
        _rightImageV.layer.cornerRadius = 8.0f;
        _rightImageV.transform = CGAffineTransformMakeRotation(M_PI/18);
        _rightImageV.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageV.clipsToBounds = YES;
        _rightImageV.layer.borderWidth = 3.0f;
        _rightImageV.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [_contentView addSubview:imageV];
        [_contentView addSubview:_promptLabel];
        [_contentView addSubview:self.oneBtn];
        [_contentView addSubview:self.twoBtn];
        [_contentView addSubview:_lefImageV];
        [_contentView addSubview:_rightImageV];
    }
    return _contentView;
}


@end

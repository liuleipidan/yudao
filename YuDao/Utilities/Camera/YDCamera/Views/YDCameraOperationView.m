//
//  YDCameraOperationView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCameraOperationView.h"
#import "YDCameraShotButton.h"
#import "YDCameraProgressView.h"

static CGFloat const kCameraBtnWidth = 68.0f;

@interface YDCameraOperationView()<YDCameraShotButtonDelegate>

@property (nonatomic, strong) YDCameraShotButton *shotBtn;

@property (nonatomic, strong) YDCameraProgressView *progressView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *afreshBtn;

@property (nonatomic, strong) UIButton *ensureBtn;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation YDCameraOperationView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self co_initSubviews];
        [self co_addMasonry];
        
        //功能初始化
        [self setDisableVideo:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tipLabel.hidden = YES;
        });
    }
    return self;
}

- (void)setDisableVideo:(BOOL)disableVideo{
    _disableVideo = disableVideo;
    if (disableVideo) {
        _tipLabel.text = @"轻触拍照";
        self.shotBtn.disableLongpress = YES;
    }
    else{
        _tipLabel.text = @"轻触拍照，按照摄像";
    }
}

#pragma mark - Events
- (void)co_backButtonAction:(UIButton *)sender{
    if (_delgate && [_delgate respondsToSelector:@selector(goBack)]) {
        [_delgate goBack];
    }
}

- (void)co_afreshButtonAction:(UIButton *)sender{
    [self co_afreshAnimation];
    if (_delgate && [_delgate respondsToSelector:@selector(afreshShot)]) {
        [_delgate afreshShot];
    }
}

- (void)co_ensureButtonAction:(UIButton *)sender{
    if (_delgate && [_delgate respondsToSelector:@selector(ensure)]) {
        [_delgate ensure];
    }
}

#pragma mark - YDCameraShotButtonDelegate
- (void)cameraShotButtonSingleClicked:(YDCameraShotButton *)button{
    _backBtn.hidden = YES;
    
    if (_delgate && [_delgate respondsToSelector:@selector(photographCompletion:)]) {
        [_delgate photographCompletion:^(BOOL success) {
            if (success) {
                [self co_shotAniamtion];
            }
            else{
                [YDMBPTool showText:@"拍摄失败"];
                _backBtn.hidden = NO;
                _shotBtn.hidden = NO;
            }
        }];
    }
}

- (void)cameraShotButtonStartRecord:(YDCameraShotButton *)button{
    _backBtn.hidden = YES;
    [_progressView setTimeMax:kRecordTimeMax];
    
    if (_delgate && [_delgate respondsToSelector:@selector(startRecord)]) {
        [_delgate startRecord];
    }
}

- (void)cameraShotButtonEndRecord:(YDCameraShotButton *)button{
    [self co_shotAniamtion];
    [_progressView clearProgress];
    
    if (_delgate && [_delgate respondsToSelector:@selector(endRecord)]) {
        [_delgate endRecord];
    }
}

#pragma mark - Aniamtions
//点击拍摄动画
- (void)co_shotAniamtion{
    _backBtn.hidden = YES;
    _shotBtn.hidden = YES;
    
    _afreshBtn.hidden = NO;
    _ensureBtn.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        [_afreshBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_shotBtn.mas_right).offset(-kCameraBtnWidth-35);
        }];
        
        [_ensureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_shotBtn.mas_left).offset(kCameraBtnWidth+35);
        }];
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

//重新拍摄动画
- (void)co_afreshAnimation{
    _afreshBtn.hidden = YES;
    _ensureBtn.hidden = YES;
    _backBtn.hidden = NO;
    _shotBtn.hidden = NO;
    
    [_afreshBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_shotBtn.mas_right);
    }];
    
    [_ensureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shotBtn.mas_left);
    }];
}

#pragma mark - Private Methods
- (void)co_initSubviews{
    _shotBtn = [YDCameraShotButton new];
    _shotBtn.delegate = self;
    
    _progressView = [[YDCameraProgressView alloc] initWithFrame:CGRectZero];
    _progressView.hidden = YES;
    YDWeakSelf(self);
    [_progressView setTimeOverBlock:^{
        [weakself cameraShotButtonEndRecord:nil];
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:@"hVideo_back" imageHL:@"hVideo_back"];
    [_backBtn addTarget:self action:@selector(co_backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _afreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_afreshBtn setImage:@"camera_btn_afresh" imageHL:@"camera_btn_afresh"];
    [_afreshBtn addTarget:self action:@selector(co_afreshButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _afreshBtn.hidden = YES;
    
    _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ensureBtn setImage:@"camera_btn_ensure" imageHL:@"camera_btn_ensure"];
    [_ensureBtn addTarget:self action:@selector(co_ensureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _ensureBtn.hidden = YES;
    
    _tipLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_14] textAlignment:NSTextAlignmentCenter];
    
    [self yd_addSubviews:@[_backBtn,_afreshBtn,_ensureBtn,_shotBtn,_progressView,_tipLabel]];
}

- (void)co_addMasonry{
    [_shotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
        make.width.height.mas_equalTo(kCameraBtnWidth);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_shotBtn);
        make.width.height.mas_equalTo(outerRingMax);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shotBtn);
        make.right.equalTo(_shotBtn.mas_left).offset(-75);
        make.size.mas_equalTo(CGSizeMake(25, 30));
    }];
    
    [_afreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shotBtn);
        make.right.equalTo(_shotBtn.mas_right);
        make.width.height.mas_equalTo(kCameraBtnWidth);
    }];
    
    [_ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shotBtn);
        make.left.equalTo(_shotBtn.mas_left);
        make.width.height.mas_equalTo(kCameraBtnWidth);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_shotBtn.mas_top).offset(-15);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(150);
    }];
}

@end

//
//  WJCameraPreview.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "WJCameraPreview.h"
#import "WJProgressView.h"

#define kTipTitle @"轻触拍照，按住摄像"

@interface WJCameraPreview()

@property (nonatomic, strong) WJProgressView *progressView;

@property (nonatomic, strong) UIImageView *focusImgV;

@property (nonatomic, strong) UILongPressGestureRecognizer *longpress;

//提示语
@property (nonatomic, strong) UILabel *tipTitleLabel;

//拍摄
@property (nonatomic, strong) UIImageView *recordImgV;

//返回
@property (nonatomic, strong) UIButton *backBtn;

//重新录制
@property (nonatomic, strong) UIButton *afreshBtn;

//确认
@property (nonatomic, strong) UIButton *ensureBtn;

//摄像头切换
@property (nonatomic, strong) UIButton *switchCameraBtn;

//截图框
@property (nonatomic, strong) YDClipImageView *clipView;

@end

@implementation WJCameraPreview
{
    CGFloat kRecordImgWH;
    CGFloat kProgressWH;
    CGFloat kBackBtnWH;
    CGFloat kEnsureBtnWH;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        kRecordImgWH = 70;
        kProgressWH = 90;
        kBackBtnWH = 40;
        kEnsureBtnWH = 70;
        
        [self initSubviews];
        [self addActions];
        [self addGestureRecognizers];
        
        [self showTipTitle];
        
        [self setDisableVideo:NO];
        [self setOpenClip:NO];
        [self setDisableSwitchButton:NO];
        [self setDisableSwitchButton:NO];
    }
    return self;
}

#pragma mark - Setter
- (void)setOpenClip:(BOOL)openClip{
    _openClip = openClip;
    self.clipView.hidden = !openClip;
}
- (void)setDisableSwitchButton:(BOOL)disableSwitchButton{
    _disableSwitchButton = disableSwitchButton;
    _switchCameraBtn.hidden = disableSwitchButton;
}
- (void)setDisableVideo:(BOOL)disableVideo{
    _disableVideo = disableVideo;
    if (disableVideo) {
        [_longpress removeTarget:nil action:nil];
    }
    
    _tipTitleLabel.text = disableVideo ? @"轻触拍照" : kTipTitle;
}

#pragma mark - Private Methods
//添加手势
- (void)addGestureRecognizers{
    UITapGestureRecognizer *tapFocus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScreenFocusAction:)];
    [_bgImgV addGestureRecognizer:tapFocus];
    
    UITapGestureRecognizer *tapRecord = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecordImgVAction:)];
    [_recordImgV addGestureRecognizer:tapRecord];
    
    _longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImgVAction:)];
    _longpress.minimumPressDuration = 1;
    _longpress.allowableMovement = kProgressWH;
    //MARK:暂时关闭摄像功能
    [_recordImgV addGestureRecognizer:_longpress];
}
//添加按钮事件
- (void)addActions{
    YDWeakSelf(self);
    [_progressView setTimeOverBlock:^{
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(cameraPreviewStartRecord:)]) {
            [weakself.delegate cameraPreviewEndRecord:weakself];
        }
    }];
    [_switchCameraBtn addTarget:self action:@selector(clickSwitchCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn addTarget:self action:@selector(clickBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_ensureBtn addTarget:self action:@selector(clickEnsureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_afreshBtn addTarget:self action:@selector(clickAfreshBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

//重新拍摄视图复位
- (void)afreshRecord{
    _isVideo = NO;
    _recordImgV.hidden = NO;
    _backBtn.hidden = NO;
    _ensureBtn.hidden = YES;
    _afreshBtn.hidden = YES;
    CGPoint ensurePoint = _ensureBtn.center;
    CGPoint afreshPoint = _afreshBtn.center;
    ensurePoint.x -= 80;
    afreshPoint.x += 80;
    _ensureBtn.center = ensurePoint;
    _afreshBtn.center = afreshPoint;
}

//完成拍摄视图位移
- (void)completionRecord{
    _recordImgV.hidden = YES;
    _backBtn.hidden = YES;
    _ensureBtn.hidden = NO;
    _afreshBtn.hidden = NO;
    CGPoint ensurePoint = _ensureBtn.center;
    CGPoint afreshPoint = _afreshBtn.center;
    ensurePoint.x += 80;
    afreshPoint.x -= 80;
    [UIView animateWithDuration:0.25 animations:^{
        _ensureBtn.center = ensurePoint;
        _afreshBtn.center = afreshPoint;
    } completion:^(BOOL finished) {
        
    }];
}

//显示或隐藏提示语
- (void)showTipTitle{
    _tipTitleLabel.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tipTitleLabel.hidden = YES;
    });
}

#pragma mark - Actions
//拍照
- (void)tapRecordImgVAction:(UITapGestureRecognizer *)tap{
    _isVideo = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreviewPhotograph:)]) {
        _recordImgV.hidden = YES;
        _backBtn.hidden = YES;
        [self.delegate cameraPreviewPhotograph:self];
    }
}

//录制视频
- (void)longPressImgVAction:(UILongPressGestureRecognizer *)lp{
        switch (lp.state) {
        case UIGestureRecognizerStateBegan:
        {
            _isVideo = YES;
            _backBtn.hidden = YES;
            
            [_progressView setTimeMax:kRecordTimeMax];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreviewStartRecord:)]) {
                [self.delegate cameraPreviewStartRecord:self];
            }
            break;}
        case UIGestureRecognizerStateChanged:
            
            break;
        case UIGestureRecognizerStateEnded:
        {
            [_progressView clearProgress];
            [self completionRecord];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreviewEndRecord:)]) {
                [self.delegate cameraPreviewEndRecord:self];
            }
            break;}
        default:
            break;
    }
}

//点击屏幕聚焦
- (void)clickScreenFocusAction:(UITapGestureRecognizer *)tap{
    if (_showImgV.image || _isVideo) {
        return;
    }
    CGPoint point = [tap locationInView:tap.view];
    _focusImgV.center = point;
    _focusImgV.transform = CGAffineTransformMakeScale(1.25, 1.25);
    _focusImgV.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        _focusImgV.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            _focusImgV.alpha = 0.5;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                _focusImgV.alpha = 1;
            } completion:^(BOOL finished) {
                _focusImgV.alpha = 0;
            }];
        }];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreview:focusPoint:)]) {
        [self.delegate cameraPreview:self focusPoint:point];
    }
}

//切换镜头
- (void)clickSwitchCameraBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreview:clickSwitchCameraBtn:)]) {
        [self.delegate cameraPreview:self clickSwitchCameraBtn:sender];
    }
}

//返回
- (void)clickBackBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreview:clickBackBtn:)]) {
        [self.delegate cameraPreview:self clickBackBtn:sender];
    }
}

//确认
- (void)clickEnsureBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreview:clickEnsureBtn:)]) {
        [self.delegate cameraPreview:self clickEnsureBtn:sender];
    }
}

//重拍
- (void)clickAfreshBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPreview:clickAfreshBtn:)]) {
        [self.delegate cameraPreview:self clickAfreshBtn:sender];
    }
    [self afreshRecord];
    [self hideShowImageView];
    
    [self showTipTitle];
}

- (void)initSubviews{
    _bgImgV = [[UIImageView alloc] initWithFrame:self.bounds];
    _bgImgV.contentMode = UIViewContentModeScaleToFill;
    _bgImgV.userInteractionEnabled = YES;
    [self addSubview:_bgImgV];
    
    _clipView = [[YDClipImageView alloc] initWithFrame:self.bounds];
    [_clipView setClipImage:YDImage(@"mine_auth_camera_clip")];
    _clipView.hidden = YES;
    [self addSubview:_clipView];
    
    _switchCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchCameraBtn setImage:[UIImage imageNamed:@"btn_video_flip_camera"] forState:0];
    _switchCameraBtn.frame = CGRectMake(SCREEN_WIDTH-40-16, 24, 40, 40);
    [self addSubview:_switchCameraBtn];
    
    _recordImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hVideo_take"]];
    _recordImgV.frame = CGRectMake((SCREEN_WIDTH-kRecordImgWH)/2, SCREEN_HEIGHT-kRecordImgWH-60, kRecordImgWH, kRecordImgWH);
    _recordImgV.userInteractionEnabled = YES;
    [self addSubview:_recordImgV];
    
    _progressView = [[WJProgressView alloc] initWithFrame:CGRectMake(0, 0, kProgressWH, kProgressWH)];
    _progressView.center = _recordImgV.center;
    _progressView.hidden = YES;
    _progressView.backgroundColor = [UIColor clearColor];
    [self addSubview:_progressView];
    
    _tipTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2.0,_progressView.y-31, 150, 21)];
    _tipTitleLabel.textColor = [UIColor whiteColor];
    _tipTitleLabel.textAlignment = NSTextAlignmentCenter;
    _tipTitleLabel.text = kTipTitle;
    _tipTitleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_tipTitleLabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"hVideo_back"] forState:0];
    _backBtn.frame = CGRectMake(_recordImgV.x-kBackBtnWH-50, _recordImgV.y-(kRecordImgWH-kBackBtnWH)/2.0, kBackBtnWH, kBackBtnWH);
    CGPoint backCenter = _backBtn.center;
    backCenter.y = _recordImgV.center.y;
    _backBtn.center = backCenter;
    [self addSubview:_backBtn];
    
    _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ensureBtn setImage:[UIImage imageNamed:@"hVideo_confirm"] forState:0];
    _ensureBtn.frame = CGRectMake(0, 0, kEnsureBtnWH, kEnsureBtnWH);
    _ensureBtn.center = _recordImgV.center;
    _ensureBtn.hidden = YES;
    
    [self insertSubview:_ensureBtn belowSubview:_recordImgV];
    
    _afreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_afreshBtn setImage:[UIImage imageNamed:@"hVideo_cancel"] forState:0];
    _afreshBtn.frame = _ensureBtn.frame;
    _afreshBtn.hidden = YES;
    [self insertSubview:_afreshBtn belowSubview:_recordImgV];
    
    _focusImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hVideo_focusing"]];
    _focusImgV.frame = CGRectMake(100, 100, 60, 60);
    _focusImgV.alpha = 0;
    [self addSubview:_focusImgV];
    [self sendSubviewToBack:_bgImgV];
    
}

#pragma mark - Public Methods
//拍照后展示照片（因拍照可能会延迟，所以在此处等实际拍摄完成后弹出确认或重拍）
- (void)showImageViewWithImage:(UIImage *)image{
    if (!_showImgV) {
        _showImgV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self insertSubview:_showImgV aboveSubview:_bgImgV];
    }
    _showImgV.image = image;
    _showImgV.hidden = NO;
    [self completionRecord];
}

//重新拍照隐藏照片
- (void)hideShowImageView{
    _showImgV.image = nil;
    _showImgV.hidden = YES;
}

@end

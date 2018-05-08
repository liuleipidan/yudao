//
//  WWAVPlayerOperationView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/13.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "WWAVPlayerOperationView.h"

@interface WWAVPlayerOperationView()

//顶部工具栏
@property (nonatomic, strong) UIView *topView;
//底部工具栏
@property (nonatomic, strong) UIView *toolView;
//返回按钮
@property (nonatomic, strong) UIButton *gobackBtn;

//播放进度条
@property (nonatomic, strong) UISlider *progressSlider;
//底部播放进度条
@property (nonatomic, strong) UIProgressView *progressBar;
//当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
//全部时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
//播放按钮
@property (nonatomic, strong) UIButton *playBtn;
//播放状态
@property (nonatomic, strong) UIImageView *playImageView;
//开启或关闭声音
@property (nonatomic, strong) UIButton *turnSoundBtn;

//菊花
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

//占位图，目前设定为视频的第一桢
@property (nonatomic, strong) UIImageView *placeholderImageView;

//手势显示／隐藏操作视图
@property (nonatomic, strong) UITapGestureRecognizer *tapScreen;

@end

@implementation WWAVPlayerOperationView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self po_initSubviews];
        [self po_addMasonry];
        [self po_addGestureRecoginzers];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setDisableFunctionView:(BOOL)disableFunctionView{
    _disableFunctionView = disableFunctionView;
    if (disableFunctionView && self.tapScreen) {
        [self.tapScreen removeTarget:nil action:nil];
    }
}

- (void)showOrHideToolView{
    [UIView animateWithDuration:0.5f animations:^{
        self.topView.hidden = !self.topView.hidden;
        self.toolView.hidden = !self.toolView.hidden;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setPlaceholderImage:(UIImage *)image url:(NSString *)url{
    self.placeholderImageView.image = nil;
    self.placeholderImageView.alpha = 1;
    if (image) {
        self.placeholderImageView.image = image;
    }
    else if (url){
        [self.placeholderImageView yd_setImageFadeinWithString:url];
    }
}

- (void)showOrHidePlaceholderImage:(BOOL)hidden{
    if (hidden && self.placeholderImageView.alpha == 0) {
        return;
    }
    else if (!hidden && self.placeholderImageView.alpha == 1){
        return;
    }
    if (hidden) {
        [UIView animateWithDuration:1 animations:^{
            self.placeholderImageView.alpha = 0;
        }];
    }
    else{
        self.placeholderImageView.alpha = 1;
    }
}

- (void)turnOnOrOffSound:(BOOL)on{
    self.turnSoundBtn.selected = on;
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationView:didClicedSoundBtn:)]) {
        [_delegate AVPlayerOperationView:self didClicedSoundBtn:self.turnSoundBtn];
    }
}

- (void)play{
    self.playBtn.selected = YES;
    self.playImageView.hidden = YES;
}

- (void)pause{
    self.playBtn.selected = NO;
    self.playImageView.hidden = NO;
}

- (void)startLoading{
    [self.indicatorView startAnimating];
}
- (void)stopLoading{
    [self.indicatorView stopAnimating];
}

- (void)setCurrentTimeString:(NSString *)currentTimeString{
    _currentTimeString = currentTimeString;
    _currentTimeLabel.text = currentTimeString;
}

- (void)setTotalTimeString:(NSString *)totalTimeString{
    _totalTimeString = totalTimeString;
    _totalTimeLabel.text = totalTimeString;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _progressSlider.value = progress;
    _progressBar.progress = progress;
}

- (void)setFullScreen:(BOOL)fullScreen{
    _fullScreen = fullScreen;
    self.progressBar.hidden = fullScreen;
}

#pragma mark - Events
//返回
- (void)po_goBackButtonAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationView:didClickedCancelBtn:)]) {
        [_delegate AVPlayerOperationView:self didClickedCancelBtn:sender];
    }
}

//开关音量
- (void)po_turnOff_OnSound:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationView:didClicedSoundBtn:)]) {
        [_delegate AVPlayerOperationView:self didClicedSoundBtn:sender];
    }
}

//播放／暂停
- (void)po_playButtonAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationView:didClicedPlayBtn:)]) {
        [_delegate AVPlayerOperationView:self didClicedPlayBtn:self.playBtn];
    }
}

//点击中心播放logo
- (void)po_clickedPlayImageView:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationView:didClicedPlayBtn:)]) {
        [_delegate AVPlayerOperationView:self didClicedPlayBtn:self.playBtn];
    }
}

//进度条滑动开始
- (void)po_progressSliderDown:(UISlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationView:progressSliderDown:)]) {
        [_delegate AVPlayerOperationView:self progressSliderDown:slider];
    }
}

//进度条滑动
- (void)po_progressSliderChange:(UISlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationView:progressSliderChange:)]) {
        [_delegate AVPlayerOperationView:self progressSliderChange:slider];
    }
}
//进度条滑动结束
- (void)po_progressSliderUp:(UISlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationView:progressSliderUp:)]) {
        [_delegate AVPlayerOperationView:self progressSliderUp:slider];
    }
}


#pragma mark - GestureRecoginzer
- (void)po_addGestureRecoginzers{
    _tapScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(po_tapScreen:)];
    [self addGestureRecognizer:_tapScreen];
}

//显示或隐藏顶部和底部视图
- (void)po_tapScreen:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerOperationViewTapScreen:)]) {
        [_delegate AVPlayerOperationViewTapScreen:self];
    }
}

#pragma mark - Private Methods
- (void)po_initSubviews{
    _placeholderImageView = [UIImageView new];
    _placeholderImageView.backgroundColor = [UIColor clearColor];
    _placeholderImageView.alpha = 0;
    _placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //顶部View
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor clearColor];
    _topView.hidden = YES;
    
    _gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gobackBtn setImage:@"video_close" imageHL:@"video_close"];
    [_gobackBtn addTarget:self action:@selector(po_goBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _turnSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_turnSoundBtn setImage:@"video_turnon_sound" imageSelected:@"video_turnoff_sound"];
    [_turnSoundBtn addTarget:self action:@selector(po_turnOff_OnSound:) forControlEvents:UIControlEventTouchUpInside];
    
    [_topView addSubview:_gobackBtn];
    [_topView addSubview:_turnSoundBtn];
    
    _playImageView = [[UIImageView alloc] initWithImage:YDImage(@"video_icon_play")];
    _playImageView.hidden = YES;
    _playImageView.userInteractionEnabled = YES;
    [_playImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(po_clickedPlayImageView:)]];
    [self addSubview:_playImageView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.hidesWhenStopped = YES;
    
    //底部View
    _toolView = [UIView new];
    _toolView.backgroundColor = [UIColor clearColor];
    _toolView.hidden = YES;
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:@"video_playBtn_play" imageSelected:@"video_playBtn_pause"];
    _playBtn.selected = YES;
    [_playBtn addTarget:self action:@selector(po_playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _currentTimeLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    _currentTimeLabel.text = @"00:00";
    
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    _progressSlider.minimumValue = 0.0;
    _progressSlider.maximumValue = 1.0;
    _progressSlider.minimumTrackTintColor = [UIColor lightGrayColor];
    [_progressSlider addTarget:self action:@selector(po_progressSliderDown:) forControlEvents:UIControlEventTouchDown];
    [_progressSlider addTarget:self action:@selector(po_progressSliderChange:) forControlEvents:UIControlEventValueChanged];
    [_progressSlider addTarget:self action:@selector(po_progressSliderUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_progressSlider setThumbImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(8, 8) isCicular:YES] forState:UIControlStateNormal];
    
    _progressBar = [[UIProgressView alloc] initWithFrame:CGRectZero];
    _progressBar.progressTintColor = [UIColor orangeTextColor];
    _progressBar.trackTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    _totalTimeLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    _totalTimeLabel.text = @"00:00";
    
    [_toolView yd_addSubviews:@[_playBtn,_currentTimeLabel,_progressSlider,_totalTimeLabel]];
    
    [self yd_addSubviews:@[_placeholderImageView,_topView,_toolView,_indicatorView,_progressBar]];
}

- (void)po_addMasonry{
    [_placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(64);
    }];
    
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [_progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(3);
    }];
    
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(50);
    }];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        //make.top.equalTo(self).offset(kHeight(288));
        make.width.height.mas_equalTo(50);
    }];
    
    [_gobackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView).offset(13);
        make.centerY.equalTo(_topView);
        make.size.mas_equalTo(CGSizeMake(30, 40));
    }];
    
    [_turnSoundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topView).offset(-13);
        make.centerY.equalTo(_topView);
        make.size.mas_equalTo(CGSizeMake(30, 40));
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_toolView).mas_equalTo(0);
        make.centerY.equalTo(_toolView);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playBtn);
        make.left.equalTo(_playBtn.mas_right).offset(15);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(40);
    }];
    
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playBtn);
        make.right.equalTo(_toolView).offset(-15);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(40);
    }];
    
    [_progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playBtn);
        make.left.equalTo(_currentTimeLabel.mas_right).offset(8);
        make.right.equalTo(_totalTimeLabel.mas_left).offset(-8);
        make.height.mas_equalTo(15);
    }];
}

#pragma mark - Getters
- (BOOL)isPlaying{
    return self.playBtn.isSelected;
}

@end

//
//  WWAVPlayerView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "WWAVPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WWAVPlayerView()<WWAVPlayerOperationViewDelegate>

#pragma mark - UI
//播放器
@property (nonatomic, strong) AVPlayer *player;

//进度观察者
@property (nonatomic, strong) id playTimeObserver;

#pragma mark - Value
//当前时间
@property (nonatomic, assign) CGFloat currentTime;
//视频总时长
@property (nonatomic, assign) CGFloat totalTime;
//播放百分比
@property (nonatomic, assign) CGFloat startVideoRate;
//播放完毕
@property (nonatomic, assign) BOOL isPlayEnd;

//上一个父视图
@property (nonatomic, weak) UIView *lastSuperView;
//在上一个父视图的位置
@property (nonatomic, assign) CGRect lastSuperFrame;

@end

static WWAVPlayerView  *wwPlayerView = nil;

@implementation WWAVPlayerView

+ (WWAVPlayerView *)sharedPlayerView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wwPlayerView = [[WWAVPlayerView alloc] initWithFrame:CGRectZero];
    });
    return wwPlayerView;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        _operationView = [[WWAVPlayerOperationView alloc] initWithFrame:frame];
        _operationView.delegate = self;
        [self addSubview:_operationView];
        [_operationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self pv_addNotifications];
        
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    [self.player removeTimeObserver:self.playTimeObserver];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Public Methods
- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL fullScreen:(BOOL)fullScreen{
    if (view == nil || videoURL == nil) {
        return;
    }
    
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    [view addSubview:self];
    self.frame = view.bounds;
    
    [self playByURL:videoURL];
    
    if (fullScreen) {
        [self pv_transformToFullScreen];
    }
}

- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL placeholderImage:(UIImage *)placeholderImage{
    
    [self showInView:view videoURL:videoURL placeholderImage:placeholderImage placeholderURL:nil fullScreen:NO];
    
    [self.operationView setPlaceholderImage:placeholderImage url:nil];
}

- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL placeholderURL:(NSString *)placeholderURL{
    
    [self.operationView setPlaceholderImage:nil url:placeholderURL];
    
    [self showInView:view videoURL:videoURL placeholderImage:nil placeholderURL:placeholderURL fullScreen:NO];
}

- (void)playByPath:(NSString *)path{
    [self playByURL:[NSURL URLWithString:path]];
}

- (void)startPlay{
    if (self.isPlayEnd) {
        [self pv_replay];
    }
    else{
        [self pv_play];
    }
}

- (void)stopPlay{
    if (self.player) {
        [self.player.currentItem cancelPendingSeeks];
        [self.player.currentItem.asset cancelLoading];
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
}

- (void)resetPlayer{
    if (self.playTimeObserver) {
        [self.player removeTimeObserver:self.playTimeObserver];
        self.playTimeObserver = nil;
    }
    
    self.player = nil;
    
    [self.operationView setProgress:0.0];
}

- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL placeholderImage:(UIImage *)placeholderImage placeholderURL:(NSString *)placeholderURL fullScreen:(BOOL)fullScreen{
    [self.operationView setPlaceholderImage:placeholderImage url:placeholderURL];
    [self showInView:view videoURL:videoURL fullScreen:fullScreen];
}

- (void)fullScreenPlay:(NSURL *)videoURL placeholderImage:(UIImage *)placeholderImage rect:(CGRect)rect{
    [self.operationView setPlaceholderImage:placeholderImage url:nil];
    
    _lastSuperFrame = rect;
    [self setFrame:rect];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.operationView.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = window.bounds;
        [self setNeedsLayout];
    } completion:^(BOOL finished) {
        [self playByURL:videoURL];
        self.operationView.hidden = NO;
        [self.operationView setFullScreen:YES];
        [self.operationView turnOnOrOffSound:NO];
    }];
}

- (void)playByURL:(NSURL *)URL{
    _videoURL = URL;
    
    [self.operationView startLoading];
    
    [self resetPlayer];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:URL];
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:nil];

        if (status == AVKeyValueStatusLoaded) {
            WWAVPlayerItem *item = [[WWAVPlayerItem alloc] initWithAsset:asset];
            item.observer = self;
            [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            if (self.player) {
                [self.player removeTimeObserver:self.playTimeObserver];
                [self.player replaceCurrentItemWithPlayerItem:item];
            }
            else{
                self.player = [[AVPlayer alloc] initWithPlayerItem:item];
            }
            
            //非全屏静音
            if (!self.isFullScreen) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.operationView turnOnOrOffSound:YES];
                });
            }
            
            YDWeakSelf(self);
            YDWeakSelf(_player);
            YDWeakSelf(_operationView)
            self.playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                float currentTime = CMTimeGetSeconds(weak_player.currentItem.currentTime);
                float rate = currentTime * 1.0 / weakself.totalTime;

                if (rate >= 0.0 && rate <= 1.0) {
                    [weak_operationView setProgress:rate];
                    [weak_operationView setCurrentTimeString:[YDVideoUtil getVideoTimeString:currentTime]];
                }
            }];
        }
        else{
            NSLog(@"视频加载失败");
            [self.operationView stopLoading];
        }
    }];
}

#pragma mark - WWAVPlayerOperationViewDelegate
//点击取消按钮
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view didClickedCancelBtn:(UIButton *)cancelBtn{
    //优先走代理
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerViewDidClickCloseBtn:)]){
        [_delegate AVPlayerViewDidClickCloseBtn:self];
    }
    else if (self.isFullScreen) {
        [self.operationView showOrHideToolView];
        [self pv_transformToLastSuperView];
    }
    
}

//点击声音按钮
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view didClicedSoundBtn:(UIButton *)soundBtn{
    //soundBtn.selected ? [self.player setVolume:0.0] : [self.player setVolume:1.0];
    soundBtn.selected ? [self.player setMuted:YES] : [self.player setMuted:NO];
    
}

//点击播放／暂停，左下角按钮和中心的播放icon共用这一个代理方法
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view didClicedPlayBtn:(UIButton *)playBtn{
    if (self.isPlayEnd) {
        [self pv_replay];
    }
    else{
        playBtn.selected ? [self pv_pause] : [self pv_play];
    }
}

//进度条滑动开始
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view progressSliderDown:(UISlider *)slider{
    [self pv_pause];
}

//进度条滑动
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view progressSliderChange:(UISlider *)slider{
    if (self.player) {
        CMTime duration = self.player.currentItem.duration;
        float currentTime = slider.value;
        [self.operationView setCurrentTimeString:[YDVideoUtil getVideoTimeString:(NSInteger)(currentTime * self.totalTime)]];
        [self.player seekToTime:CMTimeMultiplyByFloat64(duration, currentTime)];
    }
}

//进度条滑动结束
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view progressSliderUp:(UISlider *)slider{
    [self pv_play];
}

- (void)AVPlayerOperationViewTapScreen:(WWAVPlayerOperationView *)view{
    if (self.isFullScreen) {
        [self.operationView showOrHideToolView];
    }
    else{
        [self pv_transformToFullScreen];
    }
}

#pragma mark - Private Methods
//播放
- (void)pv_play{
    if (self.player) {
        [self.player play];
        [self.operationView play];
        self.state = WWPlayerStatePlaying;
    }
}
//重播
- (void)pv_replay{
    if (self.player) {
        [self.player seekToTime:CMTimeMake(0, 1)];
        [self pv_play];
        self.isPlayEnd = NO;
    }
}

//暂停
- (void)pv_pause{
    if (self.player) {
        [self.player pause];
        [self.operationView pause];
        self.state = WWPlayerStatePause;
    }
}

//全屏
- (void)pv_transformToFullScreen{
    self.operationView.hidden = YES;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    _lastSuperFrame = [self.superview convertRect:self.frame toView:window];
    //记录上一个父视图
    _lastSuperView = self.superview;
    [self removeFromSuperview];
    
    [window addSubview:self];
    [self setFrame:_lastSuperFrame];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = window.bounds;
        [self setNeedsLayout];
    } completion:^(BOOL finished) {
        self.operationView.hidden = NO;
        [self.operationView setFullScreen:YES];
        [self.operationView turnOnOrOffSound:NO];
    }];
}

//回到未全屏时的父视图
- (void)pv_transformToLastSuperView{
    self.operationView.hidden = YES;
    [self.operationView turnOnOrOffSound:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = _lastSuperFrame;
        [self setNeedsLayout];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (_lastSuperView) {
            [_lastSuperView addSubview:self];
            [self setFrame:_lastSuperView.bounds];
        }
        self.operationView.hidden = NO;
        [self.operationView setFullScreen:NO];
    }];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    AVPlayerItem *item = object;
    if ([keyPath isEqualToString:@"status"]) {
        if (item.status == AVPlayerStatusReadyToPlay) {
            NSInteger currentTime = CMTimeGetSeconds(item.currentTime);
            self.totalTime = CMTimeGetSeconds(item.duration);
            float rate = currentTime * 1.0 / self.totalTime;
            if (rate >= 0.0 && rate <= 1.0) {
                [self.operationView setProgress:rate];
                [self.operationView setTotalTimeString:[YDVideoUtil getVideoTimeString:self.totalTime]];
                [self.operationView setCurrentTimeString:[YDVideoUtil getVideoTimeString:currentTime]];
            }
            
            //将播放器和播放视图关联起来
            [self setPlayer:self.player];
            
            [self pv_play];
            
            [self.operationView stopLoading];
            
            if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerViewWillStartPlay:)]) {
                [_delegate AVPlayerViewWillStartPlay:self];
            }
        }
        else if (item.status == AVPlayerStatusFailed){
            self.state = WWPlayerStateFailed;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval time = [YDVideoUtil getVideoBufferTime:self.player.currentItem];
        float rate = time / self.totalTime;
        if (rate >= 0.0 && rate <= 1.0) {
            //NSLog(@"缓冲进度:%f",rate);
        }
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        if (self.player.currentItem.playbackBufferEmpty) {
            self.state = WWPlayerStateBuffering;
        }
        
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        if (self.player.currentItem.playbackLikelyToKeepUp && self.state == WWPlayerStateBuffering) {
            self.state = WWPlayerStatePlaying;
        }
    }
}




#pragma mark - NSNotification Center
- (void)pv_addNotifications{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //程序进入后台
    [center addObserver:self selector:@selector(pv_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    //视频播放结束
    [center addObserver:self selector:@selector(pv_videoPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //音频播放中断
    [center addObserver:self selector:@selector(pv_audioInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)pv_applicationWillResignActive:(NSNotification *)noti{
    [self pv_pause];
}

- (void)pv_videoPlayDidEnd:(NSNotification *)noti{
    if (_delegate && [_delegate respondsToSelector:@selector(AVPlayerViewDidEndPlay:)]) {
        [_delegate AVPlayerViewDidEndPlay:self];
    }
    [self.operationView pause];
    self.isPlayEnd = YES;
    if (self.autoReplay) {
        [self pv_replay];
    }
}

- (void)pv_audioInterruption:(NSNotification *)noti{
    NSDictionary *interuptionDict = noti.userInfo;
    NSInteger interuptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    NSNumber  *seccondReason  = [[noti userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] ;
    switch (interuptionType) {
        case AVAudioSessionInterruptionTypeBegan:
        {
            //收到中断，停止音频播放
            [self pv_pause];
            break;
        }
        case AVAudioSessionInterruptionTypeEnded:
            //系统中断结束
            break;
    }
    switch ([seccondReason integerValue]) {
        case AVAudioSessionInterruptionOptionShouldResume:
            //恢复音频播放
            [self pv_play];
            break;
        default:
            break;
    }
}

#pragma mark - Setter
////每个视图都对应一个层，改变视图的形状、动画效果\与播放器的关联等，都可以在层上操作
- (void)setPlayer:(AVPlayer *)myPlayer
{
    _player = myPlayer;
    dispatch_async(dispatch_get_main_queue(), ^{
        AVPlayerLayer *playerLayer=(AVPlayerLayer *)self.layer;
        [playerLayer setPlayer:myPlayer];
    });
}

- (void)setState:(WWPlayerState)state{
    _state = state;
    if (state == WWPlayerStateBuffering) {
        [self.operationView startLoading];
    }
    else{
        [self.operationView stopLoading];
    }
    
    if (state == WWPlayerStatePlaying || state == WWPlayerStateBuffering) {
        // 隐藏占位图
        [self.operationView showOrHidePlaceholderImage:YES];
    }
}

- (void)setDisableControl:(BOOL)disableControl{
    _disableControl = disableControl;
    if (disableControl) {
        [self.operationView removeFromSuperview];
    }
}

#pragma mark  - Getter
//在调用视图的layer时，会自动触发layerClass方法，重写它，保证返回的类型是AVPlayerLayer
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (BOOL)isFullScreen{
    return self.width == [UIScreen mainScreen].bounds.size.width;
}

@end

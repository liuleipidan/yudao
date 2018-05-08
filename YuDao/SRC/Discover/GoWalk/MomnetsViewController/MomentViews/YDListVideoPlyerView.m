//
//  YDListVideoPlyerView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/12.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDListVideoPlyerView.h"
#import "WWAVPlayerItem.h"

@interface YDListVideoPlyerView()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *totalTimeLabel;

@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) id timeObserver;

@property (nonatomic, assign) BOOL isPlayEnd;

//视频总时长
@property (nonatomic, assign) CGFloat totalTime;

@property (nonatomic, strong) NSURL *videoURL;

@end

static YDListVideoPlyerView *lvPlayView;

@implementation YDListVideoPlyerView

+ (YDListVideoPlyerView *)sharedPlyerView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lvPlayView = [[YDListVideoPlyerView alloc] init];
    });
    return lvPlayView;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        [self lp_initSubviews];
        [self lp_addMasonry];
        
        [self lp_addNotifications];
        
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    [self.player removeTimeObserver:self.timeObserver];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL{
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    if (view == nil || videoURL == nil) {
        return;
    }
    
    [view addSubview:self];
    self.frame = view.bounds;
    
    [self playWithURL:videoURL];
}

- (void)stopPlay{
    if (self.player) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
}

#pragma mark - Events
//进度条滑动开始
- (void)lp_progressSliderDown:(UISlider *)slider{
    
}

//进度条滑动
- (void)lp_progressSliderChange:(UISlider *)slider{
    
}
//进度条滑动结束
- (void)lp_progressSliderUp:(UISlider *)slider{
    
}

- (void)pv_playButtonAction:(UITapGestureRecognizer *)tap{
    if (self.isPlayEnd) {
        [self lp_replay];
    }
    else{
        [self lp_play];
    }
}

#pragma mark - NSNotification Center
- (void)lp_addNotifications{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //程序进入后台
    [center addObserver:self selector:@selector(lp_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    //视频播放结束
    [center addObserver:self selector:@selector(lp_videoPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //音频播放中断
    [center addObserver:self selector:@selector(lp_audioInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)lp_applicationWillResignActive:(NSNotification *)noti{
    [self lp_pause];
}

- (void)lp_videoPlayDidEnd:(NSNotification *)noti{
    
    self.isPlayEnd = YES;
}

- (void)lp_audioInterruption:(NSNotification *)noti{
    NSDictionary *interuptionDict = noti.userInfo;
    NSInteger interuptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    NSNumber  *seccondReason  = [[noti userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] ;
    switch (interuptionType) {
        case AVAudioSessionInterruptionTypeBegan:
        {
            //收到中断，停止音频播放
            [self lp_pause];
            break;
        }
        case AVAudioSessionInterruptionTypeEnded:
            //系统中断结束
            break;
    }
    switch ([seccondReason integerValue]) {
        case AVAudioSessionInterruptionOptionShouldResume:
            //恢复音频播放
            [self lp_play];
            break;
        default:
            break;
    }
}

#pragma mark - Private Methods
//播放
- (void)lp_play{
    if (self.player) {
        [self.player play];
    }
}
//重播
- (void)lp_replay{
    if (self.player) {
        [self.player seekToTime:CMTimeMake(0, 1)];
        [self.player play];
    }
}
//暂停
- (void)lp_pause{
    if (self.player) {
        [self.player pause];
    }
}
- (void)lp_initSubviews{
    _iconImageView = [[UIImageView alloc] initWithImage:YDImage(@"")];
    
    _totalTimeLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_14] textAlignment:NSTextAlignmentRight];
    _totalTimeLabel.text = @"00:00";
    
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    _progressSlider.minimumValue = 0.0;
    _progressSlider.maximumValue = 1.0;
    _progressSlider.minimumTrackTintColor = [UIColor orangeTextColor];
    [_progressSlider addTarget:self action:@selector(lp_progressSliderDown:) forControlEvents:UIControlEventTouchDown];
    [_progressSlider addTarget:self action:@selector(lp_progressSliderChange:) forControlEvents:UIControlEventValueChanged];
    [_progressSlider addTarget:self action:@selector(lp_progressSliderUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_progressSlider setThumbTintColor:[UIColor clearColor]];
    
    [self yd_addSubviews:@[_iconImageView,_totalTimeLabel,_progressSlider]];
}

- (void)lp_addMasonry{
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(50);
    }];
    
    [_progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(3);
    }];
    
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-5);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(40);
    }];
}

- (void)playWithURL:(NSURL *)URL{
    if (self.videoURL) {
        [self stopPlay];
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:URL];
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:nil];
        if (status == AVKeyValueStatusLoaded) {
            WWAVPlayerItem *item = [[WWAVPlayerItem alloc] initWithAsset:asset];
            item.observer = self;
            [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            if (self.player) {
                [self.player removeTimeObserver:self.timeObserver];
                [self.player replaceCurrentItemWithPlayerItem:item];
            }
            else{
                self.player = [[AVPlayer alloc] initWithPlayerItem:item];
            }
            YDWeakSelf(self);
            YDWeakSelf(_player);
            YDWeakSelf(_progressSlider);
            self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                float currentTime = CMTimeGetSeconds(weak_player.currentItem.currentTime);
                float rate = currentTime * 1.0 / weakself.totalTime;
                if (rate >= 0.0 && rate <= 1.0) {
                    weak_progressSlider.value = rate;
                }
                
            }];
        }
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
                self.progressSlider.value = rate;
                self.totalTimeLabel.text = [YDVideoUtil getVideoTimeString:self.totalTime];
            }
            
            //将播放器和播放视图关联起来
            [self setPlayer:self.player];
            [self lp_play];
        }
        else if (item.status == AVPlayerStatusFailed){
            NSLog(@"AVPlayerStatusFailed");
        }
        else{
            NSLog(@"AVPlayerStatusUnknown");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval time = [YDVideoUtil getVideoBufferTime:self.player.currentItem];
        float rate = time / self.totalTime;
        if (rate >= 0.0 && rate <= 1.0) {
            NSLog(@"缓冲进度:%f",rate);
        }
    }
}

#pragma mark - Setter & Getter
//每个视图都对应一个层，改变视图的形状、动画效果\与播放器的关联等，都可以在层上操作
- (void)setPlayer:(AVPlayer *)myPlayer
{
    _player = myPlayer;
    dispatch_async(dispatch_get_main_queue(), ^{
        AVPlayerLayer *playerLayer=(AVPlayerLayer *)self.layer;
        [playerLayer setPlayer:myPlayer];
    });
}

//在调用视图的layer时，会自动触发layerClass方法，重写它，保证返回的类型是AVPlayerLayer
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

@end

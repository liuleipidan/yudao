//
//  YDAVPlayer.m
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "YDAVPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface YDAVPlayer ()

@property (nonatomic,strong) AVPlayer *player;//播放器对象

@end

@implementation YDAVPlayer


- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url {
    if (self = [self initWithFrame:frame]) {
        
        [bgView addSubview:self];
    }
    return self;
}

- (void)dealloc {
    [self removeAvPlayerNtf];
    [self stopPlayer];
    self.player = nil;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    
    [self.layer addSublayer:self.playerLayer];
    [self.player play];
}

- (void)nextPlayer {
    [self addAVPlayerNtf:self.player.currentItem];
    if (self.player.rate == 0) {
        [self.player play];
    }
}

- (void)addAVPlayerNtf:(AVPlayerItem *)playerItem {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeAvPlayerNtf {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopPlayer {
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
}


- (void)playbackFinished:(NSNotification *)ntf {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}


#pragma mark - Getters
- (AVPlayer *)player {
    if (_player == nil) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addAVPlayerNtf:_player.currentItem];
    }
    return _player;
}

- (CALayer *)playerLayer
{
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    return playerLayer;
}

@end

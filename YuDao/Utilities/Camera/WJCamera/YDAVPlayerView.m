//
//  YDAVPlayerView.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/12.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDAVPlayerView.h"

@implementation YDAVPlayerView

+ (YDAVPlayerView *)showInView:(UIView *)view{
    NSLog(@"%s",__func__);
    YDAVPlayerView *playView = [[YDAVPlayerView alloc] initWithFrame:view.bounds];
    [view addSubview:playView];
    return playView;
}


- (void)stopPlayer{
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
}


- (CALayer *)playerLayer
{
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    return playerLayer;
}

-(void)setPlayUrl:(NSURL *)playUrl{
    _playUrl = playUrl;
    [self.layer addSublayer:self.playerLayer];
    [self.player play];
    
}

- (AVPlayer *)player{
    if (!_player) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.playUrl];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addObserverToPlayerItem:playerItem];
    }
    return _player;
}

-(void)playbackFinished:(NSNotification *)notification{
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - notification method
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    NSLog(@"%s",__func__);
    //    [playerItem removeObserver:self forKeyPath:@"status"];
    //    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self.player pause];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    NSLog(@"%s",__FUNCTION__);
}

@end

//
//  YDAudioPlayer.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

#define kProximityMonitoring  @"kProximityMonitoring";

@interface YDAudioPlayer()<AVAudioPlayerDelegate>

@property (nonatomic, strong) void (^ completeBlock)(BOOL finished);

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation YDAudioPlayer

+ (YDAudioPlayer *)sharedAudioPlayer
{
    static YDAudioPlayer *audioPlayer;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        audioPlayer = [[YDAudioPlayer alloc] init];
    });
    return audioPlayer;
}

#pragma mark - Public Methods
- (void)playAudioAtPath:(NSString *)path complete:(void (^)(BOOL finished))complete;
{
    if (self.player && self.player.isPlaying) {
        [self stopPlayingAudio];
        [self stopProximityMonitoring];
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self startProximityMonitoring];
    self.completeBlock = complete;
    NSError *error;
    if (path == nil) {
        return;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    [self.player setDelegate:self];
    if (error) {
        if (complete) {
            complete(NO);
        }
        return;
    }
    [self.player play];
}

- (void)stopPlayingAudio
{
    NSLog(@"%s",__func__);
    [self.player stop];
    [self stopProximityMonitoring];
    if (self.completeBlock) {
        self.completeBlock(NO);
    }
}

- (void)startProximityMonitoring{
    NSLog(@"开启红外监测");
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [YDNotificationCenter addObserver:self selector:@selector(proximityMonitoringChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)stopProximityMonitoring{
    NSLog(@"关闭红外监测,%s",__func__);
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [YDNotificationCenter removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}

#pragma mark - Private Methods
- (void)proximityMonitoringChange:(NSNotification *)noti{
    BOOL state = [[UIDevice currentDevice] proximityState];
    if (state) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (BOOL)isPlaying
{
    if (self.player) {
        return self.player.isPlaying;
    }
    return NO;
}

#pragma mark - # Delegate
//MARK: AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopProximityMonitoring];
    if (self.completeBlock) {
        self.completeBlock(YES);
        self.completeBlock = nil;
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self stopProximityMonitoring];
    YDLog(@"音频播放出现错误：%@", error);
    if (self.completeBlock) {
        self.completeBlock(NO);
        self.completeBlock = nil;
    }
}

@end

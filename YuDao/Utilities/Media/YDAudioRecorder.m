//
//  YDAudioRecorder.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//
//YDAudioRecorder
#import "YDAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

#define     PATH_RECFILE        [[NSFileManager cachesPath] stringByAppendingString:@"/rec.wav"]

@interface YDAudioRecorder()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) void (^volumeChangedBlock)(CGFloat valume);
@property (nonatomic, strong) void (^completeBlock)(NSString *path, CGFloat time);
@property (nonatomic, strong) void (^cancelBlock)(void);

@end

static YDAudioRecorder *audioRecorder = nil;
static dispatch_once_t ar_onceToken;

@implementation YDAudioRecorder

+ (YDAudioRecorder *)sharedRecorder{
    dispatch_once(&ar_onceToken, ^{
        audioRecorder = [[YDAudioRecorder alloc] init];
    });
    return audioRecorder;
}

+ (void)attemptDealloc{
    ar_onceToken = 0;
    [audioRecorder stopRecording];
    audioRecorder = nil;
}

- (void)startRecordingWithVolumeChangedBlock:(void (^)(CGFloat volume))volumeChanged
                               completeBlock:(void (^)(NSString *path, CGFloat time))complete
                                 cancelBlock:(void (^)(void))cancel;
{
    YDLog(@"startRecordingWithVolumeChangedBlock111");
    self.volumeChangedBlock = volumeChanged;
    self.completeBlock = complete;
    self.cancelBlock = cancel;
    if ([[NSFileManager defaultManager] fileExistsAtPath:PATH_RECFILE]) {
        [[NSFileManager defaultManager] removeItemAtPath:PATH_RECFILE error:nil];
    }
    [self.recorder prepareToRecord];
    [self.recorder record];
    YDLog(@"self.timer = %@",self.timer);
    if (self.timer) {
        NSLog(@"startRecordingWithVolumeChangedBlock222");
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(volumeChanged) userInfo:nil repeats:YES];
    YDLog(@"startRecordingWithVolumeChangedBlock333");
}

- (void)volumeChanged{
    [self.recorder updateMeters];
    float peakPower = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    if (self && self.volumeChangedBlock) {
        self.volumeChangedBlock(peakPower);
    }
}

- (void)stopRecording
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    CGFloat time = self.recorder.currentTime;
    [self.recorder stop];
    self.recorder = nil;
    if (self.completeBlock) {
        self.completeBlock(PATH_RECFILE, time);
        self.completeBlock = nil;
    }
}

- (void)cancelRecording
{
    [self.timer invalidate];
    [self.recorder stop];
    self.recorder = nil;
    if (self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        //        NSLog(@"录音成功");
    }
}

#pragma mark - # Getter
- (AVAudioRecorder *)recorder
{
    if (_recorder == nil) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if(session == nil){
            YDLog(@"Error creating session: %@", [sessionError description]);
            return nil;
        }
        else {
            [session setActive:YES error:nil];
        }
        
        // 设置录音的一些参数
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[AVFormatIDKey] = @(kAudioFormatLinearPCM);                // 音频格式
        setting[AVSampleRateKey] = @(1600);                            // 录音采样率(Hz)
        setting[AVNumberOfChannelsKey] = @(1);                          // 音频通道数 1 或 2
        setting[AVLinearPCMBitDepthKey] = @(16);                         // 线性音频的位深度
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];        //录音的质量
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recFilePath] settings:setting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
    }
    return _recorder;
}

- (NSString *)recFilePath
{
    return PATH_RECFILE;
}



@end

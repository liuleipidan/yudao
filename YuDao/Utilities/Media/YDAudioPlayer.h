//
//  YDAudioPlayer.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDAudioPlayer : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;

+ (YDAudioPlayer *)sharedAudioPlayer;

/**
 开始方法语音

 @param path 语音文件本地路径
 @param complete 播放完成回调
 */
- (void)playAudioAtPath:(NSString *)path complete:(void (^)(BOOL finished))complete;

/**
 停止播放语音
 */
- (void)stopPlayingAudio;

/**
 开启红外监测
 */
- (void)startProximityMonitoring;

/**
 关闭红外监测
 */
- (void)stopProximityMonitoring;

@end

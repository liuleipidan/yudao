//
//  WWAVPlayerView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWAVPlayerItem.h"
#import "WWAVPlayerOperationView.h"

//播放器的状态
typedef NS_ENUM(NSInteger, WWPlayerState) {
    WWPlayerStateFailed,     // 播放失败
    WWPlayerStateBuffering,  // 缓冲中
    WWPlayerStatePlaying,    // 播放中
    WWPlayerStateStopped,    // 停止播放
    WWPlayerStatePause       // 暂停播放
};

@class WWAVPlayerView;
@protocol WWAVPlayerViewDelegate<NSObject>

@optional
- (void)AVPlayerViewDidClickCloseBtn:(WWAVPlayerView *)view;

- (void)AVPlayerViewWillStartPlay:(WWAVPlayerView *)view;

- (void)AVPlayerViewDidEndPlay:(WWAVPlayerView *)view;

@end

@interface WWAVPlayerView : UIView

+ (WWAVPlayerView *)sharedPlayerView;

@property (nonatomic, weak  ) id<WWAVPlayerViewDelegate> delegate;

@property (nonatomic, strong) WWAVPlayerOperationView *operationView;

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, assign) WWPlayerState state;

//是否已经是全屏
@property (nonatomic, assign, readonly) BOOL isFullScreen;

//自动重播，默认NO
@property (nonatomic, assign) BOOL autoReplay;

//关闭用户控制
@property (nonatomic, assign) BOOL disableControl;

//播放结束自动从父视图移除
@property (nonatomic, assign) BOOL removeWhenEnd;

- (void)playByPath:(NSString *)path;

- (void)playByURL:(NSURL *)URL;

- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL placeholderURL:(NSString *)placeholderURL;

- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL placeholderImage:(UIImage *)placeholderImage;

- (void)showInView:(UIView *)view videoURL:(NSURL *)videoURL placeholderImage:(UIImage *)placeholderImage placeholderURL:(NSString *)placeholderURL fullScreen:(BOOL)fullScreen;

- (void)startPlay;

- (void)stopPlay;

- (void)fullScreenPlay:(NSURL *)videoURL placeholderImage:(UIImage *)placeholderImage rect:(CGRect)rect;

@end

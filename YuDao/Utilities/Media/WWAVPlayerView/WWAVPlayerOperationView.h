//
//  WWAVPlayerOperationView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/13.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWAVPlayerOperationView;
@protocol WWAVPlayerOperationViewDelegate <NSObject>

//点击取消按钮
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view didClickedCancelBtn:(UIButton *)cancelBtn;

//点击声音按钮
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view didClicedSoundBtn:(UIButton *)soundBtn;

//点击播放／暂停，左下角按钮和中心的播放icon共用这一个代理方法
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view didClicedPlayBtn:(UIButton *)playBtn;

//进度条滑动开始
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view progressSliderDown:(UISlider *)slider;

//进度条滑动
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view progressSliderChange:(UISlider *)slider;

//进度条滑动结束
- (void)AVPlayerOperationView:(WWAVPlayerOperationView *)view progressSliderUp:(UISlider *)slider;

//点击屏幕
- (void)AVPlayerOperationViewTapScreen:(WWAVPlayerOperationView *)view;

@end

@interface WWAVPlayerOperationView : UIView

@property (nonatomic, weak  ) id<WWAVPlayerOperationViewDelegate> delegate;

//正在播放
@property (nonatomic, assign, readonly) BOOL isPlaying;

//关闭操作视图，包括顶部和底部的操作视图
@property (nonatomic, assign) BOOL disableFunctionView;

@property (nonatomic, copy  ) NSString *currentTimeString;

@property (nonatomic, copy  ) NSString *totalTimeString;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) BOOL fullScreen;

- (void)showOrHideToolView;

- (void)setPlaceholderImage:(UIImage *)image url:(NSString *)url;

- (void)showOrHidePlaceholderImage:(BOOL)hidden;

- (void)turnOnOrOffSound:(BOOL)on;

- (void)play;

- (void)pause;

- (void)startLoading;

- (void)stopLoading;

@end

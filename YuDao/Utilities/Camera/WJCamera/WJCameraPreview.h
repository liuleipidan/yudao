//
//  WJCameraPreview.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDClipImageView.h"

//最大录制时间 10s
#define kRecordTimeMax 10

//最小录制时间 1s
#define kRecordTimeMin 1

@class WJCameraPreview;
@protocol WJCameraPreviewDelegate <NSObject>

//开始录制
- (void)cameraPreviewStartRecord:(WJCameraPreview *)preview;

//结束录制
- (void)cameraPreviewEndRecord:(WJCameraPreview *)preview;

//重新录制
- (void)cameraPreview:(WJCameraPreview *)preview clickAfreshBtn:(UIButton *)afreshBtn;

//拍照
- (void)cameraPreviewPhotograph:(WJCameraPreview *)preview;

//返回
- (void)cameraPreview:(WJCameraPreview *)preview clickBackBtn:(UIButton *)backBtn;

//确认
- (void)cameraPreview:(WJCameraPreview *)preview clickEnsureBtn:(UIButton *)ensureBtn;

//旋转摄像头
- (void)cameraPreview:(WJCameraPreview *)preview clickSwitchCameraBtn:(UIButton *)cameraBtn;

//聚焦
- (void)cameraPreview:(WJCameraPreview *)preview focusPoint:(CGPoint )point;

@end

@interface WJCameraPreview : UIView

@property (nonatomic,weak) id<WJCameraPreviewDelegate> delegate;

//用于填充摄像预览
@property (nonatomic, strong) UIImageView *bgImgV;

//拍照后用来展示
@property (nonatomic, strong) UIImageView *showImgV;

//是否是摄像 YES 代表是录制  NO 表示拍照（默认）
@property (nonatomic, assign) BOOL isVideo;

//视频太短
@property (nonatomic, assign) BOOL videoTooShort;

#pragma mark - Setting
//开启截图视图，默认NO
@property (nonatomic, assign) BOOL openClip;

//关闭视频录制，默认NO
@property (nonatomic, assign) BOOL disableVideo;

//隐藏切换镜头按钮，默认NO
@property (nonatomic, assign) BOOL disableSwitchButton;

//拍照后展示照片
- (void)showImageViewWithImage:(UIImage *)image;

//重新拍照隐藏照片
- (void)hideShowImageView;

@end

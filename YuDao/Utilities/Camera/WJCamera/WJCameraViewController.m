//
//  WJCameraViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "WJCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YDAVPlayerView.h"
@import Photos;

@interface WJCameraViewController ()<WJCameraPreviewDelegate,AVCaptureFileOutputRecordingDelegate>
//负责输入和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession *captureSession;
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;
//负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
//图片输出流
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
//视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieOutput;

//图像预览层，实时显示捕获的图像
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//后台任务标识
@property (nonatomic, assign) UIBackgroundRefreshStatus backgroundTaskIdentifier;
@property (nonatomic, assign) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

//聚焦光标
@property (nonatomic, strong) UIImageView *focusCursor;

//视频播放视图
@property (nonatomic, strong) YDAVPlayerView *player;
//视频保存路径
@property (nonatomic, strong) NSURL *saveVideoUrl;

@end

@implementation WJCameraViewController

- (id)init{
    if (self = [super init]) {
        _preview = [[WJCameraPreview alloc] initWithFrame:self.view.bounds];
        _preview.delegate = self;
        [self.view addSubview:_preview];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkCameraAndMircrophonePermissions];
}

- (void)dealloc{
    NSLog(@"self.class = %@ dealloc",self.class);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] yd_setStatusBarHidden:YES];
    
    [self customCamera];
    [_captureSession startRunning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] yd_setStatusBarHidden:NO];
    [self.player stopPlayer];
    [_captureSession stopRunning];
}

- (void)setPreview:(WJCameraPreview *)preview{
    _preview = preview;
}

- (void)setDisableVideo:(BOOL)disableVideo{
    
    [self.preview setDisableVideo:disableVideo];
}

//检查摄像头和麦克风权限
- (void)checkCameraAndMircrophonePermissions{
    //如果没有权限
    YDWeakSelf(self);
    __block BOOL cameraGranted = YES;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        cameraGranted = granted;
        
    }];
    __block BOOL mircrophoneGranted = YES;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        mircrophoneGranted = granted;
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!cameraGranted || !mircrophoneGranted) {
            
            [UIAlertController YD_OK_AlertController:self title:@"请在iPhone的\"设置-隐私\"中选项中允许遇道访问你的摄像头和麦克风" clickBlock:^{
                [weakself dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    });
    
}



- (void)customCamera{
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    else{
        [_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    //后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    //添加音频输入设备
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio].firstObject;
    
    //初始化摄像头输入
    NSError *error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        YDLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //初始化音频输入
    error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        YDLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    
    
    //将输入设备添加到捕捉会话
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        //视频防抖
        AVCaptureConnection *connection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    //输出对象
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    //将输出设备添加到捕捉会话（初始为照片对象）
    if ([_captureSession canAddOutput:_movieOutput]) {
        [_captureSession addOutput:_movieOutput];
    }
    
    //将照片输出添加到捕捉会话
    _imageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([_captureSession canAddOutput:_imageOutput]) {
        [_captureSession addOutput:_imageOutput];
    }
    
    //创建视频预览层，用于实施展示摄像头状态
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.frame = self.view.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [self.preview.bgImgV.layer addSublayer:_previewLayer];
}

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }
    else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

#pragma mark  - WJCameraPreviewDelegate
//拍照
- (void)cameraPreviewPhotograph:(WJCameraPreview *)preview{
    AVCaptureConnection *connection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!connection) {
        YDLog(@"拍照失败");
        return;
    }
    YDWeakSelf(self);
    [_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == nil) {
            return ;
        }
        NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:data];
        [weakself.preview showImageViewWithImage:image];
        [weakself.captureSession stopRunning];
    }];
}

//点击开始录制
- (void)cameraPreviewStartRecord:(WJCameraPreview *)preview{
    
    //根据设备输出获得连接
    AVCaptureConnection *connection = [_movieOutput connectionWithMediaType:AVMediaTypeAudio];
    //根据连接取得设备输出的数据
    if (![_movieOutput isRecording]) {
        //如果支持多任务则开始多任务
//        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
//            self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//        }
        if (self.saveVideoUrl) {
            [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
        }
        //预览图层和视频方向保持一致
        connection.videoOrientation = [self.previewLayer connection].videoOrientation;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [_movieOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
    else {
        [_movieOutput stopRecording];
    }
}
//松开结束录制
- (void)cameraPreviewEndRecord:(WJCameraPreview *)preview{
    YDLog(@"松开结束录制");
    [_movieOutput stopRecording];//停止录制
    [_captureSession stopRunning];
}
//返回
- (void)cameraPreview:(WJCameraPreview *)preview clickBackBtn:(UIButton *)backBtn{
    [self.player stopPlayer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//重新拍摄
- (void)cameraPreview:(WJCameraPreview *)preview clickAfreshBtn:(UIButton *)afreshBtn{
    _saveVideoUrl = nil;
    if (_preview.isVideo) {
        [_player stopPlayer];
        [_player removeFromSuperview];
        _player = nil;
    }
    else{
        [_preview hideShowImageView];
    }
    
    _lastBackgroundTaskIdentifier = _backgroundTaskIdentifier;
    _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [_captureSession startRunning];
}
//确认
- (void)cameraPreview:(WJCameraPreview *)preview clickEnsureBtn:(UIButton *)ensureBtn{
    
    if (_preview.isVideo && self.takeVideoBlock && _saveVideoUrl) {
        self.takeVideoBlock(_saveVideoUrl, [UIImage getThumbnailImage:_saveVideoUrl]);
    }
    else if (_takeImageBlock){
        _takeImageBlock(_preview.showImgV.image);
    }
    //[[UIApplication sharedApplication] endBackgroundTask:@""];
    [self saveImage:_preview.showImgV.image orVideo:_saveVideoUrl];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//保存图片或者视频（有权限则保存，无权限不保存）
- (void)saveImage:(UIImage *)image orVideo:(NSURL *)videlUrl{
    
    if (image && !self.disableAutoSaveImage) {//保存照片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    else if (videlUrl && !self.disableAutoSaveVideo){
        [YDVideoUtil saveVideoWithURL:videlUrl completion:^(NSError *error) {
            
        }];
        //
        //        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        //        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:_saveVideoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
        //            [[NSFileManager defaultManager] removeItemAtURL:weakself.saveVideoUrl error:nil];
        //            if (weakself.lastBackgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        //                [[UIApplication sharedApplication] endBackgroundTask:weakself.lastBackgroundTaskIdentifier];
        //            }
        //            if (error) {
        //                YDLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        //                [YDMBPTool showText:@"保存视频失败"];
        //            }
        //            else {
        //                //回调
        //                if (weakself.takeVideoBlock) {
        //                    UIImage *thumbnailImage = [UIImage getThumbnailImage:assetURL];
        //                    weakself.takeVideoBlock(assetURL,thumbnailImage);
        //                }
        //                [weakself dismissViewControllerAnimated:YES completion:nil];
        //            }
        //        }];
    }
}

//旋转摄像头
- (void)cameraPreview:(WJCameraPreview *)preview clickSwitchCameraBtn:(UIButton *)cameraBtn{
    YDLog(@"旋转摄像头");
    AVCaptureDevice *currentDevice = [_captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    AVCaptureDevice *toDevice;
    AVCaptureDevicePosition toPosition = AVCaptureDevicePositionFront;//前
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toPosition = AVCaptureDevicePositionBack;//后
    }
    toDevice = [self getCameraDeviceWithPosition:toPosition];
    //新建设备输入对象
    AVCaptureDeviceInput *toInput = [[AVCaptureDeviceInput alloc] initWithDevice:toDevice error:nil];
    //改变会话前须先开启配置，备置完后提交配置改变
    [_captureSession beginConfiguration];
    //移除原有输入对象
    [_captureSession removeInput:_captureDeviceInput];
    //添加新的输入对象
    if ([_captureSession canAddInput:toInput]) {
        [_captureSession addInput:toInput];
        _captureDeviceInput = toInput;
    }
    [_captureSession commitConfiguration];
}
//聚焦
- (void)cameraPreview:(WJCameraPreview *)preview focusPoint:(CGPoint )point{
    CGPoint cameraPoint = [_previewLayer captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
//开始录制
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制");
    
}
//视频录制完成
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"视频录制完成 outputFileURL = %@",outputFileURL);
    _saveVideoUrl = outputFileURL;
    if (outputFileURL) {
        _player = [YDAVPlayerView showInView:_preview.bgImgV];
        [_player setPlayUrl:outputFileURL];
    }
}


@end

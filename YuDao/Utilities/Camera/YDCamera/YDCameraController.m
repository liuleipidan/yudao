
//
//  YDCameraController.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCameraController.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^DevicePropertyChangeBlock)(AVCaptureDevice *device);

@interface YDCameraController ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;

@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;

@property (nonatomic, strong) AVCaptureMovieFileOutput *videoOutput;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//聚焦光标
@property (nonatomic, strong) UIImageView *focusCursorImageView;

@property (nonatomic,copy) void (^endRecordBlock )(NSURL *videoURL);

//摄像头初始化遮盖图
@property (nonatomic, strong) UIImageView *overImageView;

@end

@implementation YDCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self cc_addGestureRecognizers];
    
    [self.view addSubview:self.focusCursorImageView];
    [self.view addSubview:self.overImageView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.captureSession) {
        
        [self startRunning];
        //聚焦中心点
        [self cc_setFocusPointAndFocusCursorAnimationAtPoint:self.view.center];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.overImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
        
        if (_delegate && [_delegate respondsToSelector:@selector(cameraControllerInitSuccess:)]) {
            [_delegate cameraControllerInitSuccess:self];
        }
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(cameraController:initFailed:)]) {
            [_delegate cameraController:self initFailed:@"相机初始化失败"];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopRunning];
}

#pragma mark - Public Methods
- (void)startRunning{
    if (!self.captureSession.isRunning) {
        [self.captureSession startRunning];
    }
}

- (void)stopRunning{
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
    }
}

- (void)photographCompletion:(void (^)(UIImage *image))completed{
    AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection == nil) {
        completed(nil);
        return;
    }
    
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (imageDataSampleBuffer == nil) {
            completed(nil);
        }
        else{
            NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:data];
            completed(image);
        }
        #pragma mark - stopRunning
        //[weakself.captureSession stopRunning];
    }];
}

- (void)startRecord{
    AVCaptureConnection *connection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    if (self.videoOutput.isRecording) {
        [self.videoOutput stopRecording];
    }
    
    connection.videoOrientation = [self.previewLayer connection].videoOrientation;
    NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingString:@"YDvideo.mov"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    }
    NSURL *fileURL = [NSURL fileURLWithPath:outputFilePath];
    [self.videoOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}

- (void)endRecordCompletion:(void (^)(NSURL *))compeltion{
    _endRecordBlock = compeltion;
    [self.videoOutput stopRecording];
    #pragma mark - stopRunning - 为了更好的视觉效果
    //[self.captureSession stopRunning];
}

//设置闪光灯模式
- (void)setFlashMode:(AVCaptureFlashMode)flashMode{
    [self cc_changeDeviceProperty:^(AVCaptureDevice *device) {
        if ([device isFlashModeSupported:flashMode]) {
            [device setFlashMode:flashMode];
        }
    }];
}

//设置聚焦模式
- (void)setFocusMode:(AVCaptureFocusMode)focusMode{
    [self cc_changeDeviceProperty:^(AVCaptureDevice *device) {
        if ([device isFocusModeSupported:focusMode]) {
            [device setFocusMode:focusMode];
        }
    }];
}

//设置曝光模式
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self cc_changeDeviceProperty:^(AVCaptureDevice *device) {
        if ([device isExposureModeSupported:exposureMode]) {
            [device setExposureMode:exposureMode];
        }
    }];
}

//设置聚焦点
- (void)setFocusWithMode:(AVCaptureFocusMode )focusMode exposureMode:(AVCaptureExposureMode)exposureMode point:(CGPoint)point{
    [self cc_changeDeviceProperty:^(AVCaptureDevice *device) {
        if ([device isFocusModeSupported:focusMode]) {
            [device setFocusMode:focusMode];
        }
        if ([device isFocusPointOfInterestSupported]) {
            [device setFocusPointOfInterest:point];
        }
        if ([device isExposureModeSupported:exposureMode]) {
            [device setExposureMode:exposureMode];
        }
        if ([device isExposurePointOfInterestSupported]) {
            [device setExposurePointOfInterest:point];
        }
    }];
}

//切换镜头
- (void)exchangeCameraPosition{
    AVCaptureDevice *currentDevice = [self.deviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    AVCaptureDevice *toDevice;
    AVCaptureDevicePosition toPosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toPosition = AVCaptureDevicePositionBack;
    }
    
    toDevice = [self cc_getCameraDeviceByPosition:toPosition];
    
    //改变会话配置前，要先开启配置，配置完成后提交 beginConfiguration和commitConfiguration成对出现
    [self.captureSession beginConfiguration];
    //移除原有的输入对象
    [self.captureSession removeInput:self.deviceInput];
    
    //获取新的输入对象
    AVCaptureDeviceInput *toInput = [[AVCaptureDeviceInput alloc] initWithDevice:toDevice error:nil];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toInput]) {
        [self.captureSession addInput:toInput];
        self.deviceInput = toInput;
    }
    
    //提交配置修改
    [self.captureSession commitConfiguration];
}

#pragma mark - Private Methods
//获取设备
- (AVCaptureDevice *)cc_getCameraDeviceByPosition:(AVCaptureDevicePosition )position{
    __block AVCaptureDevice *device = nil;
    [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] enumerateObjectsUsingBlock:^(AVCaptureDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.position == position) {
            device = obj;
            *stop = YES;
        }
    }];
    return device;
}

//修改设备属性
- (void)cc_changeDeviceProperty:(DevicePropertyChangeBlock )propertyChangeBlock{
    AVCaptureDevice *device = [self.deviceInput device];
    NSError *error = nil;
    //改变设备属性前一定要先调用lockForConfiguration:，之后使用unlockForConfiguration解锁
    if ([device lockForConfiguration:&error]) {
        if (propertyChangeBlock) {
            propertyChangeBlock(device);
        }
        [device unlockForConfiguration];
    }
    else{
        NSLog(@"修改设备属性发生错误:%@",error.localizedDescription);
    }
}

//添加手势
- (void)cc_addGestureRecognizers{
    UITapGestureRecognizer *tapScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cc_tapScreen:)];
    [self.view addGestureRecognizer:tapScreen];
}

//点击屏幕屏幕
- (void)cc_tapScreen:(UITapGestureRecognizer *)tap{
    CGPoint tapPoint = [tap locationInView:self.view];
    [self cc_setFocusPointAndFocusCursorAnimationAtPoint:tapPoint];
}

//设置聚焦点和聚焦光标动画
- (void)cc_setFocusPointAndFocusCursorAnimationAtPoint:(CGPoint)point{
    //UI坐标转摄像头坐标
    CGPoint cameraPoiont = [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose point:cameraPoiont];
    
    //动画
    self.focusCursorImageView.center = point;
    self.focusCursorImageView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    self.focusCursorImageView.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCursorImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.alpha = 0;
    }];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
//开始录制
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections{
    
}
//结束录制
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error{
    
    if (_endRecordBlock) {
        _endRecordBlock(outputFileURL);
    }
}

#pragma mark - Getters
- (AVCaptureSession *)captureSession{
    if (_captureSession == nil) {
        
        //视频输入
        AVCaptureDevice *videoCaptureDevice = [self cc_getCameraDeviceByPosition:AVCaptureDevicePositionBack];
        if (videoCaptureDevice == nil) {
            NSLog(@"获取后置摄像头出问题");
            return nil;
        }
        NSError *videoError = nil;
       _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&videoError];
        if (videoError) {
            NSLog(@"初始化摄像输入有问题");
            return nil;
        }
        
        //音频输入
        NSError *audioError = nil;
        AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio].firstObject;
        AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&audioError];
        if (audioError) {
            NSLog(@"初始化音频输入有问题");
            return nil;
        }
        
        //视频输出
        _videoOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        //图片输出
        _imageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *imageOutputSettings = @{
                                              AVVideoCodecKey:AVVideoCodecJPEG
                                              };
        [_imageOutput setOutputSettings:imageOutputSettings];
        
        _captureSession = [[AVCaptureSession alloc] init];
        //设置分辨率
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        }
        else{
            [_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
        }
        
        //将设备输入添加到捕捉会话
        if ([_captureSession canAddInput:_deviceInput]) {
            [_captureSession addInput:_deviceInput];
        }
        if ([_captureSession canAddInput:audioCaptureDeviceInput]) {
            [_captureSession addInput:audioCaptureDeviceInput];
        }
        
        //将设备输入添加到捕捉会话
        if ([_captureSession canAddOutput:_videoOutput]) {
            [_captureSession addOutput:_videoOutput];
            //视频防抖，没测过
            AVCaptureConnection *connection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
            if (connection.isVideoStabilizationSupported) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
            }
        }
        if ([_captureSession canAddOutput:_imageOutput]) {
            [_captureSession addOutput:_imageOutput];
        }
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_previewLayer setFrame:self.view.layer.bounds];
    }
    return _previewLayer;
}

- (UIImageView *)focusCursorImageView{
    if (_focusCursorImageView == nil) {
        _focusCursorImageView = [[UIImageView alloc] initWithImage:YDImage(@"hVideo_focusing")];
        _focusCursorImageView.frame = CGRectMake(0, 0, 60, 60);
        _focusCursorImageView.alpha = 0;
    }
    return _focusCursorImageView;
}

- (UIImageView *)overImageView{
    if (_overImageView == nil) {
        _overImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _overImageView.backgroundColor = [UIColor blackColor];
    }
    return _overImageView;
}

@end

//
//  YDScannerController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDScannerController.h"
#import "YDScannerView.h"
#import "YDScannerBackgroundView.h"
#import <AVFoundation/AVFoundation.h>

@interface YDScannerController ()<AVCaptureMetadataOutputObjectsDelegate>

//介绍
@property (nonatomic, strong) UILabel *introductionLabel;

//更多
@property (nonatomic, strong) UIButton *moreButton;

//扫描器视图
@property (nonatomic, strong) YDScannerView *scannerView;

//扫描器背景视图
@property (nonatomic, strong) YDScannerBackgroundView *scannerBGView;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *scannerSession;

//预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation YDScannerController

+ (void)scannerQRCodeFromImage:(UIImage *)image completion:(void (^)(NSString *))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 1));
        CIImage *ciImage = [CIImage imageWithData:imageData];
        NSString  *text = nil;
        if (ciImage) {
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:nil] options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
            NSArray *features = [detector featuresInImage:ciImage];
            if (features.count) {
                for (CIFeature *feature in features) {
                    if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
                        text = ((CIQRCodeFeature *)feature).messageString;
                        break;
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(text);
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view yd_addSubviews:@[self.scannerView,self.scannerBGView,self.introductionLabel,self.moreButton]];
   
    
    [self sc_addMasonry];
    
    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.scannerSession) {
        if (_delegate && [_delegate respondsToSelector:@selector(scannerControllerInitSuccess:)]) {
            [_delegate scannerControllerInitSuccess:self];
        }
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(scannerController:initFailed:)]) {
            [_delegate scannerController:self initFailed:@"相机初始化失败"];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.scannerSession isRunning]) {
        [self stopQRCodeReading];
    }
}

#pragma mark - Public Methods
- (void)setDisableMoreButton:(BOOL)disableMoreButton{
    _disableMoreButton = disableMoreButton;
    self.moreButton.hidden = disableMoreButton;
}
- (void)setScannerType:(YDScannerType)scannerType{
    if (scannerType != YDScannerTypeAll
        && _scannerType == scannerType) {
        return;
    }
    _scannerType = scannerType;
    CGFloat width = 0;
    CGFloat height = 0;
    width = height = SCREEN_WIDTH * 0.7;
    self.introductionLabel.text = @"将二维码放入框中，即可自动扫描";
    self.moreButton.hidden = _disableMoreButton;
    //老版UI
//    if (scannerType == YDScannerTypeQRUser) {
//        self.introductionLabel.text = @"将好友二维码放入框中，即可自动扫描";
//        width = height = SCREEN_WIDTH * 0.7;
//        self.moreButton.hidden = YES;
//    }
//    else if (scannerType == YDScannerTypeQRDevice){
//        self.introductionLabel.text = @"将设备二维码放入框中，即可自动扫描";
//        width = height = SCREEN_WIDTH * 0.7;
//        self.moreButton.hidden = self.disableMoreButton;
//    }
    
    [self.scannerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.view layoutIfNeeded];
    
    // rect值范围0-1，基准点在右上角
    CGRect rect = CGRectMake(self.scannerView.y / SCREEN_HEIGHT, self.scannerView.x / SCREEN_WIDTH, self.scannerView.height / SCREEN_HEIGHT, self.scannerView.width / SCREEN_WIDTH);
    [self.scannerSession.outputs[0] setRectOfInterest:rect];
    if (!self.isRunning) {
        [self startQRCodeReading];
    }
}

- (void)startQRCodeReading{
    [self.scannerView startScanner];
    [self.scannerSession startRunning];
}

- (void)stopQRCodeReading{
    [self.scannerView stopScanner];
    [self.scannerSession stopRunning];
    //关灯
    [self turnOffOrOnTheLight:YES];
}

- (void)turnOffOrOnTheLight:(BOOL)off{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (off) {
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    else{
        [device setTorchMode:device.torchMode == AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    }
    [device unlockForConfiguration];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        //关闭自动停止扫描，使用手动控制
        //[self stopQRCodeReading];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        if (_delegate && [_delegate respondsToSelector:@selector(scannerController:scanCompletionString:)]) {
            [_delegate scannerController:self scanCompletionString:obj.stringValue];
        }
    }
}
#pragma mark - Private Method
- (void)sc_moreButtonAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(scannerController:clickMoreButton:)]) {
        [_delegate scannerController:self clickMoreButton:sender];
    }
}

- (void)sc_addMasonry{
    [self.scannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).mas_offset(-55);
        make.width.and.height.mas_equalTo(0);
    }];
    
    [self.scannerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.scannerBGView addMasonryWithContainView:self.scannerView];
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.scannerView.mas_bottom).mas_offset(20);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.introductionLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - Getters
- (BOOL)isRunning{
    return [self.scannerSession isRunning];
}

- (AVCaptureSession *)scannerSession
{
    if (_scannerSession == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (error) {    // 没有摄像头
            return nil;
        }
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            [session setSessionPreset:AVCaptureSessionPreset1920x1080];
        }
        else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [session setSessionPreset:AVCaptureSessionPreset1280x720];
        }
        else {
            [session setSessionPreset:AVCaptureSessionPresetPhoto];
        }
        
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        if ([session canAddOutput:output]) {
            [session addOutput:output];
        }
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]];
        
        _scannerSession = session;
    }
    return _scannerSession;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer
{
    if (_videoPreviewLayer == nil) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.scannerSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:self.view.layer.bounds];
    }
    return _videoPreviewLayer;
}

- (UILabel *)introductionLabel{
    if (_introductionLabel == nil) {
        _introductionLabel = [UILabel new];
        [_introductionLabel setBackgroundColor:[UIColor clearColor]];
        [_introductionLabel setTextAlignment:NSTextAlignmentCenter];
        [_introductionLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_introductionLabel setTextColor:[UIColor whiteColor]];
    }
    return _introductionLabel;
}

- (UIButton *)moreButton{
    if (_moreButton == nil) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"点击查看更多" forState:UIControlStateNormal];
        [_moreButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_moreButton setTitleColor:[UIColor orangeTextColor] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(sc_moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setHidden:YES];
    }
    return _moreButton;
}

- (YDScannerView *)scannerView
{
    if (_scannerView == nil) {
        _scannerView = [YDScannerView new];
    }
    return _scannerView;
}

- (YDScannerBackgroundView *)scannerBGView
{
    if (_scannerBGView == nil) {
        _scannerBGView = [YDScannerBackgroundView new];
    }
    return _scannerBGView;
}



@end

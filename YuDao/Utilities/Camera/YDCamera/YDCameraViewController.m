//
//  YDCameraViewController.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCameraViewController.h"
#import "WWAVPlayerView.h"

@interface YDCameraViewController ()<YDCameraControllerDelegate,YDCameraOperationViewDelegate,WWAVPlayerViewDelegate>

//图片预览
@property (nonatomic, strong) UIImageView *imagePreview;
//视频预览
@property (nonatomic, strong) WWAVPlayerView *videoPreview;
//旋转摄像头
@property (nonatomic, strong) UIButton *switchButton;

@end

@implementation YDCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.cameraVC.view];
    [self addChildViewController:self.cameraVC];
    
    [self.view addSubview:self.operationView];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(130);
    }];
    
    [self.view insertSubview:self.imagePreview belowSubview:self.operationView];
    [self.view insertSubview:self.videoPreview belowSubview:self.operationView];
    [self.imagePreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.videoPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.switchButton];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-18);
        make.width.height.mas_equalTo(30);
    }];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - Public Methods
- (void)setDisableVideo:(BOOL)disableVideo{
    _disableVideo = disableVideo;
    [self.operationView setDisableVideo:disableVideo];
}

#pragma mark - Events
- (void)cc_switchButtonAction:(UIButton *)sender{
    [self.cameraVC exchangeCameraPosition];
}

- (void)image:(UIImage *)image didFinishSavineWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存图片失败");
    }
    else{
        NSLog(@"保存图片成功");
    }
}

#pragma mark - YDCameraOperationViewDelegate
//开始录制
- (void)startRecord{
    [self.cameraVC startRecord];
}

//结束录制
- (void)endRecord{
    YDWeakSelf(self);
    [self.cameraVC endRecordCompletion:^(NSURL *videoURL) {
        weakself.imagePreview.hidden = YES;
        weakself.videoPreview.hidden = NO;
        weakself.switchButton.hidden = YES;
        [weakself.videoPreview playByURL:videoURL];
    }];
}

//拍照完成
- (void)photographCompletion:(void (^)(BOOL success))completed{
    
    YDWeakSelf(self);
    [self.cameraVC photographCompletion:^(UIImage *image) {
        weakself.imagePreview.hidden = NO;
        weakself.videoPreview.hidden = YES;
        weakself.switchButton.hidden = YES;
        if (weakself.videoPreview.state == WWPlayerStatePlaying || weakself.videoPreview.state == WWPlayerStateBuffering) {
            [weakself.videoPreview stopPlay];
        }
        if (image) {
            weakself.imagePreview.image = image;
        }
        completed(image ? YES : NO);
    }];
}

//重新拍摄
- (void)afreshShot{
    if (self.imagePreview.image) {
        self.imagePreview.image = nil;
        self.imagePreview.hidden = YES;
    }
    
    if (self.videoPreview.state == WWPlayerStatePlaying || self.videoPreview.state == WWPlayerStateBuffering) {
        self.videoPreview.hidden = YES;
        [self.videoPreview stopPlay];
    }
    self.switchButton.hidden = NO;
    [self.cameraVC startRunning];
}

//确认
- (void)ensure{
    if (!self.imagePreview.hidden && _delegate && [_delegate respondsToSelector:@selector(cameraViewController:didTakeImage:)]) {
        [_delegate cameraViewController:self didTakeImage:self.imagePreview.image];
        //自动保存图片到相册
        if (!self.disableAutoSaveImage) {
            UIImageWriteToSavedPhotosAlbum(self.imagePreview.image, self, @selector(image:didFinishSavineWithError:contextInfo:), nil);
        }
    }
    else if (!self.videoPreview.hidden && _delegate && [_delegate respondsToSelector:@selector(cameraViewController:didTakeVideo:)]){
        [_delegate cameraViewController:self didTakeVideo:self.videoPreview.videoURL];
        if (!self.disableAutoSaveVideo) {
            //自动保存视频到相册
            [YDVideoUtil saveVideoWithURL:self.videoPreview.videoURL completion:^(NSError *error) {
                if (error) {
                    NSLog(@"保存视频失败");
                }
                else{
                    NSLog(@"保存视频成功");
                }
            }];
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//返回
- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - YDCameraControllerDelegate
//初始化成功
- (void)cameraControllerInitSuccess:(YDCameraController *)controller{
    NSLog(@"相册初始化成功");
}

//初始化失败
- (void)cameraController:(YDCameraController *)controller
              initFailed:(NSString *)errorString{
    [UIAlertController YD_OK_AlertController:self title:YDNoNilString(errorString) clickBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - WWAVPlayerViewDelegate
- (void)AVPlayerViewWillStartPlay:(WWAVPlayerView *)view{
    
}

- (void)AVPlayerViewDidEndPlay:(WWAVPlayerView *)view{
    
}

#pragma mark - Getters
- (YDCameraController *)cameraVC{
    if (_cameraVC == nil) {
        _cameraVC = [[YDCameraController alloc] init];
        _cameraVC.delegate = self;
    }
    return _cameraVC;
}

- (YDCameraOperationView *)operationView{
    if (_operationView == nil) {
        _operationView = [[YDCameraOperationView alloc] initWithFrame:CGRectZero];
        _operationView.delgate = self;
    }
    return _operationView;
}

- (UIImageView *)imagePreview{
    if (_imagePreview == nil) {
        _imagePreview = [UIImageView new];
        _imagePreview.backgroundColor = [UIColor clearColor];
    }
    return _imagePreview;
}

- (WWAVPlayerView *)videoPreview{
    if (_videoPreview == nil) {
        _videoPreview = [[WWAVPlayerView alloc] initWithFrame:self.view.bounds];
        //_videoPreview.autoReplay = YES;
        _videoPreview.disableControl = YES;
        _videoPreview.hidden = YES;
        _videoPreview.backgroundColor = [UIColor clearColor];
        _videoPreview.delegate = self;
    }
    return _videoPreview;
}

- (UIButton *)switchButton{
    if (_switchButton == nil) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:@"camera_btn_switch" imageHL:@"camera_btn_switch"];
        [_switchButton addTarget:self action:@selector(cc_switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

@end

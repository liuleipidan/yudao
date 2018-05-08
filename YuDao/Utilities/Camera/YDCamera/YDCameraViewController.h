//
//  YDCameraViewController.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDCameraController.h"
#import "YDCameraOperationView.h"

@class YDCameraViewController;
@protocol YDCameraViewControllerDelegate <NSObject>

- (void)cameraViewController:(YDCameraViewController *)controller didTakeImage:(UIImage *)image;

- (void)cameraViewController:(YDCameraViewController *)controller didTakeVideo:(NSURL *)videoURL;

@end

@interface YDCameraViewController : YDViewController

@property (nonatomic, weak  ) id<YDCameraViewControllerDelegate> delegate;

@property (nonatomic, strong) YDCameraController *cameraVC;

@property (nonatomic, strong) YDCameraOperationView *operationView;

//关闭视频录制，默认是NO
@property (nonatomic, assign) BOOL disableVideo;

//关闭自动保存图片，默认NO
@property (nonatomic, assign) BOOL disableAutoSaveImage;

//关闭自动保存视频，默认NO
@property (nonatomic, assign) BOOL disableAutoSaveVideo;

@end

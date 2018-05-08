//
//  WJCameraViewController.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCameraPreview.h"
#import "YDAVPlayer.h"

@interface WJCameraViewController : UIViewController

@property (nonatomic,copy) void (^takeImageBlock) (UIImage *image);

@property (nonatomic,copy) void (^takeVideoBlock) (NSURL *videoUrl, UIImage *thumbnailImage);

//操作视图
@property (nonatomic, strong) WJCameraPreview *preview;

//关闭视频录制，默认是NO
@property (nonatomic, assign) BOOL disableVideo;

//关闭自动保存图片，默认NO
@property (nonatomic, assign) BOOL disableAutoSaveImage;

//关闭自动保存视频，默认NO
@property (nonatomic, assign) BOOL disableAutoSaveVideo;

@end

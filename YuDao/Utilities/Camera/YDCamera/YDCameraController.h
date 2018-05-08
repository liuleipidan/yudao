//
//  YDCameraController.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDCameraController;
@protocol YDCameraControllerDelegate <NSObject>

@required
//初始化失败
- (void)cameraController:(YDCameraController *)controller
               initFailed:(NSString *)errorString;

@optional
//初始化成功
- (void)cameraControllerInitSuccess:(YDCameraController *)controller;

@end

@interface YDCameraController : UIViewController

@property (nonatomic, weak  ) id<YDCameraControllerDelegate> delegate;

//开始运行
- (void)startRunning;

//停止运行
- (void)stopRunning;

//拍照完成
- (void)photographCompletion:(void (^)(UIImage *image))completed;

//开始录制
- (void)startRecord;

//结束录制
- (void)endRecordCompletion:(void (^)(NSURL *videoURL))compeltion;

//切换镜头
- (void)exchangeCameraPosition;

@end

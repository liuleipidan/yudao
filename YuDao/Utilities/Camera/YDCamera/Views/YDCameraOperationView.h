//
//  YDCameraOperationView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YDCameraOperationViewDelegate <NSObject>

//开始录制
- (void)startRecord;

//结束录制
- (void)endRecord;

//拍照完成
- (void)photographCompletion:(void (^)(BOOL success))completed;

//重新拍摄
- (void)afreshShot;

//确认
- (void)ensure;

//返回
- (void)goBack;

@end

@interface YDCameraOperationView : UIView

//关闭视频功能，默认NO
@property (nonatomic, assign) BOOL disableVideo;

@property (nonatomic, weak  ) id<YDCameraOperationViewDelegate> delgate;

@end

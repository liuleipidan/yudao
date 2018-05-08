//
//  YDScannerController.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"

@class YDScannerController;
@protocol YDScannerControllerDelegate <NSObject>

//初始化成功
- (void)scannerControllerInitSuccess:(YDScannerController *)controller;

//初始化失败
- (void)scannerController:(YDScannerController *)controller
               initFailed:(NSString *)errorString;

//扫面完成
- (void)scannerController:(YDScannerController *)controller scanCompletionString:(NSString *)string;

@optional
//点击更多
- (void)scannerController:(YDScannerController *)controller clickMoreButton:(UIButton *)sender;

@end

@interface YDScannerController : YDViewController

@property (nonatomic, assign) YDScannerType scannerType;

@property (nonatomic, weak  ) id<YDScannerControllerDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isRunning;

//关闭更多按钮，默认是NO
@property (nonatomic, assign) BOOL disableMoreButton;

//开始扫描
- (void)startQRCodeReading;

//结束扫面
- (void)stopQRCodeReading;

//打开或关闭照明,off==YES时，强行关闭
- (void)turnOffOrOnTheLight:(BOOL)off;

//扫描图片
+ (void)scannerQRCodeFromImage:(UIImage *)image completion:(void (^)(NSString *string))completion;

@end

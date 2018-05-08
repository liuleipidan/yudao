//
//  YDScanningController.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDScannerController.h"

@interface YDScanningController : YDViewController

//扫描器
@property (nonatomic, strong) YDScannerController *scanVC;

//从车库或车辆详情进来时需要传，否则为nil
@property (nonatomic, strong) NSNumber *ug_id;

/**
 *  禁用底部工具栏（默认NO，若开启，将只支持扫码）
 */
@property (nonatomic, assign) BOOL disableFunctionBar;

//关闭更多按钮
@property (nonatomic, assign) BOOL disableMoreButton;

//关闭获得扫面结果后的自动处理，默认是NO
@property (nonatomic, assign) BOOL disableAutoHandle;

//扫描完成回调
@property (nonatomic,copy) void (^scannerCompletionBlock )(NSString *text);

//初始化后扫描的类型
- (void)initScannerType:(YDScannerType)type;

//处理扫描完的字符串
+ (void)handleScannerString:(NSString *)text
                isUserBlock:(void (^)(NSNumber *userId))isUserBlock
              isDeviceBlock:(void (^)(NSString *imei,NSString *authCode))isDeviceBlock
                isHttpBlock:(void (^)(NSString *url))isHttpBlock
             isUnknownBlock:(void (^)(NSString *text))isUnknownBlock;

@end

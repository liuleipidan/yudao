//
//  YDScannerViewController.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/24.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDScannerController.h"

@interface YDScannerViewController : YDViewController

//扫描类型，参考YDScannerType
@property (nonatomic, assign) YDScannerType scannerType;

//扫描器
@property (nonatomic, strong) YDScannerController *scanVC;

//从车库或车辆详情进来时需要传，否则为nil
@property (nonatomic, strong) YDCarDetailModel *carInfo;

//关闭更多按钮
@property (nonatomic, assign) BOOL disableMoreButton;

//关闭获得扫面结果后的自动处理，默认是NO
@property (nonatomic, assign) BOOL disableAutoHandle;

//扫描完成回调
@property (nonatomic,copy) void (^scannerCompletionBlock )(NSString *text);

//处理扫描完的字符串
+ (void)handleScannerString:(NSString *)text
                isUserBlock:(void (^)(NSNumber *userId))isUserBlock
              isDeviceBlock:(void (^)(NSString *imei,NSString *authCode,NSString *typeCode))isDeviceBlock
                isHttpBlock:(void (^)(NSString *url))isHttpBlock
             isUnknownBlock:(void (^)(NSString *text))isUnknownBlock;

- (void)handlecanningResult_User;

- (void)handlecanningResult_Device;

- (void)handlecanningResult_Http;

- (void)handlecanningResult_Unknown;

@end

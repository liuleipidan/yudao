//
//  YDScannerViewController.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/24.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDScannerViewController.h"
#import "YDWebController.h"
#import "YDBindDeviceIntroductionController.h"
#import "YDUserFilesController.h"
#import "YDBindDeviceController.h"
#import "NSString+RegularExpressionConfig.h"

@interface YDScannerViewController ()<YDScannerControllerDelegate>



@end

@implementation YDScannerViewController

+ (void)handleScannerText:(NSString *)text completion:(void (^)(YDScannerResultType resultType, NSDictionary *info))completion{
    if (text == nil || text.length == 0) {
        if (completion) {
            completion(YDScannerResultTypeUnknown,nil);
        }
        return;
    }
    YDScannerResultType resultType = [text re_validateScanResult];
    NSDictionary *param = nil;
    if (resultType == YDScannerResultTypeUser) {
        NSRange range = [text rangeOfString:@"&&&"];
        NSString *userId = [text substringFromIndex:range.location + range.length];
        param = @{
                  @"userId":[NSNumber numberWithInteger:userId.integerValue]
                  };
    }
    else if (resultType == YDScannerResultTypeHttp){
        param = @{
                  @"http":text
                  };
    }
    else if (resultType == YDScannerResultTypeVE_BOX ||
             resultType == YDScannerResultTypeVE_AIR){
        NSArray *array = [text componentsSeparatedByString:@"#"];
        param = @{
                  @"iMei":array.firstObject,
                  @"authCode":array.lastObject
                  };
    }
    
    if (completion) {
        completion(resultType,param);
    }
}

//处理扫描完的字符串
+ (void)handleScannerString:(NSString *)text
                isUserBlock:(void (^)(NSNumber *userId))isUserBlock
              isDeviceBlock:(void (^)(NSString *imei,NSString *authCode,NSString *typeCode))isDeviceBlock
                isHttpBlock:(void (^)(NSString *url))isHttpBlock
             isUnknownBlock:(void (^)(NSString *text))isUnknownBlock{
    if ([text hasPrefix:@"http"]) {
        NSRange range = [text rangeOfString:@"&&&"];
        //本App用户
        if (range.location != NSNotFound) {//解出了用户id
            NSString *subString = [text substringFromIndex:range.location+range.length];
            if (isUserBlock) {
                isUserBlock(@(subString.integerValue));
            }
        }
        else{//其他网址
            if (isHttpBlock) {
                isHttpBlock(text);
            }
        }
    }
    else{
        NSArray *array = [text componentsSeparatedByString:@"#"];
        NSString *xlCode,*yzCode,*typeCode;
        if (array.count == 2) {//VE-BOX
            xlCode = [array objectAtIndex:0];
            yzCode = [array objectAtIndex:1];
            isDeviceBlock(xlCode,yzCode,typeCode);
        }
        else if (array.count == 3){//VE-Air
            xlCode = [array objectAtIndex:0];
            yzCode = [array objectAtIndex:1];
            typeCode = [array objectAtIndex:2];
            isDeviceBlock(xlCode,yzCode,typeCode);
        }
        else{
            if (isUnknownBlock) {
                isUnknownBlock(text);
            }
        }
        if (isDeviceBlock) {
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"二维码"];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.scanVC.view];
    [self addChildViewController:self.scanVC];
    
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem itemWithImage:@"scanner_icon_light" target:self action:@selector(sc_lightItemAction:)]];
}

#pragma mark - Public Methods
- (void)setDisableMoreButton:(BOOL)disableMoreButton{
    [self.scanVC setDisableMoreButton:disableMoreButton];
}

- (void)setCarInfo:(YDCarDetailModel *)carInfo{
    if (carInfo == nil) {
        return;
    }
    _carInfo = carInfo;
    if (carInfo.boundDeviceType == YDCarBoundDeviceTypeNone) {
        [self setScannerType:YDScannerTypeQRDevice];
    }
    else if (carInfo.boundDeviceType == YDCarBoundDeviceTypeVE_BOX){
        [self setScannerType:YDScannerTypeQRVE_Air];
    }
    else if (carInfo.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        [self setScannerType:YDScannerTypeQRVE_BOX];
    }
    else{
        NSLog(@"错误，当前车辆已经绑定VE-BOX和VE-AIR");
    }
}

- (void)handlecanningResult_User{
    if (self.scannerType == YDScannerTypeQRDevice) {
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描设备" hideBlock:nil];
    }
    else if (self.scannerType == YDScannerTypeQRVE_BOX){
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描VE-BOX" hideBlock:nil];
    }
    else if (self.scannerType == YDScannerTypeQRVE_Air){
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描VE-AIR" hideBlock:nil];
    }
}

- (void)handlecanningResult_Device{
    if (self.scannerType == YDScannerTypeQRUser) {
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描\"遇道\"用户" hideBlock:nil];
    }
}

- (void)handlecanningResult_Http{
    if (self.scannerType == YDScannerTypeQRDevice) {
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描设备" hideBlock:nil];
    }
    else if (self.scannerType == YDScannerTypeQRVE_BOX){
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描VE-BOX" hideBlock:nil];
    }
    else if (self.scannerType == YDScannerTypeQRVE_Air){
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描VE-AIR" hideBlock:nil];
    }
    else if (self.scannerType == YDScannerTypeQRUser){
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描\"遇道\"用户" hideBlock:nil];
    }
}

- (void)handlecanningResult_Unknown{
    if (self.scannerType == YDScannerTypeQRDevice) {
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描设备" hideBlock:nil];
    }
    else if (self.scannerType == YDScannerTypeQRVE_BOX){
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描VE-BOX" hideBlock:nil];
    }
    else if (self.scannerType == YDScannerTypeQRVE_Air){
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描VE-AIR" hideBlock:nil];
    }
    else if (self.scannerType == YDScannerTypeQRUser){
        [YDMBPTool showInfoImageWithMessage:@"当前仅限扫描\"遇道\"用户" hideBlock:nil];
    }
}

#pragma mark - Events
//开启／关闭照明
- (void)sc_lightItemAction:(UIBarButtonItem *)sender{
    [self.scanVC turnOffOrOnTheLight:NO];
}

#pragma mark - YDScannerControllerDelegate
- (void)scannerControllerInitSuccess:(YDScannerController *)controller{
    if (!controller.isRunning) {
        [controller startQRCodeReading];
    }
    
    [self.scanVC setScannerType:self.scannerType];
}

//初始化失败
- (void)scannerController:(YDScannerController *)controller
               initFailed:(NSString *)errorString{
    [UIAlertController YD_OK_AlertController:self title:YDNoNilString(errorString) clickBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//扫面完成
- (void)scannerController:(YDScannerController *)controller scanCompletionString:(NSString *)string{
    
    [self scv_handleScanCompletionText:string];
}

//点击更多
- (void)scannerController:(YDScannerController *)controller clickMoreButton:(UIButton *)sender{
    YDBindDeviceIntroductionController *bindVC = [YDBindDeviceIntroductionController new];
    bindVC.carInfo = self.carInfo;
    [self.navigationController pushViewController:bindVC animated:YES];
}

#pragma mark - Private Methods
- (void)scv_handleScanCompletionText:(NSString *)text{
    if (self.disableAutoHandle) {
        [self.scanVC stopQRCodeReading];
        [self.navigationController popViewControllerAnimated:NO];
        if (self.scannerCompletionBlock) {
            self.scannerCompletionBlock(text);
        }
    }
    else{
        id rootVC = self.navigationController.rootViewController;
        YDWeakSelf(self);
        [YDScannerViewController handleScannerText:text completion:^(YDScannerResultType resultType, NSDictionary *info) {
            [weakself.scanVC stopQRCodeReading];
            if (resultType == YDScannerResultTypeUnknown) {
                [UIAlertController YD_OK_AlertController:weakself title:@"未知扫描结果" message:text clickBlock:^{
                    [weakself.scanVC startQRCodeReading];
                }];
                return ;
            }
            if (resultType == YDScannerResultTypeUser) {
                [weakself.navigationController popViewControllerAnimated:NO];
                YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:[info objectForKey:@"userId"]];
                YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
                [[rootVC navigationController] pushViewController:userVC animated:YES];
            }
            else if (resultType == YDScannerResultTypeHttp){
                [weakself.navigationController popViewControllerAnimated:NO];
                YDWebController *webVC = [YDWebController new];
                webVC.url = [info objectForKey:@"http"];
                [[rootVC navigationController] pushViewController:webVC animated:YES];
            }
            else if (resultType == YDScannerResultTypeVE_BOX ||
                     resultType == YDScannerResultTypeVE_AIR){
                [weakself.navigationController popViewControllerAnimated:NO];
                YDBindDeviceController *bindVC = [YDBindDeviceController new];
                bindVC.deviceType = resultType == YDScannerResultTypeVE_BOX ? YDBindDeviceTypeVE_AIR : YDBindDeviceTypeVE_BOX;
                bindVC.carInfo = weakself.carInfo;
                bindVC.obd_imei = [info objectForKey:@"iMei"];
                bindVC.obd_authCode = [info objectForKey:@"authCode"];
                NSDictionary *param = @{
                                        @"obd_IMEI":YDNoNilString(bindVC.obd_imei),
                                        @"obd_pin":YDNoNilString(bindVC.obd_authCode)
                                        };
                [YDLoadingHUD showLoading];
                [YDNetworking requestOBDInvitationCodeWithParamters:param complation:^(NSString *invitationCode) {
                    
                    bindVC.invitationCode = invitationCode;
                    [[rootVC navigationController] pushViewController:bindVC animated:YES];
                }];
            }
        }];
//        [YDScannerViewController handleScannerString:text isUserBlock:^(NSNumber *userId) {
//            [weakself.scanVC stopQRCodeReading];
//            if (weakself.scannerType == YDScannerTypeAll ||
//                weakself.scannerType == YDScannerTypeQRUser) {
//                
//                [weakself.navigationController popViewControllerAnimated:NO];
//                YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:userId];
//                YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
//                [[rootVC navigationController] pushViewController:userVC animated:YES];
//            }
//            else{
//                //只限用户
//                [UIAlertController YD_OK_AlertController:self title:@"当前只可扫描设备" message:nil clickBlock:^{
//                    [self.scanVC startQRCodeReading];
//                }];
//            }
//        } isDeviceBlock:^(NSString *imei, NSString *authCode, NSString *typeCode) {
//            [weakself.scanVC stopQRCodeReading];
//            if (weakself.scannerType == YDScannerTypeQRUser) {
//                //只限用户
//                [UIAlertController YD_OK_AlertController:self title:@"当前只可扫描用户" message:nil clickBlock:^{
//                    [weakself.scanVC startQRCodeReading];
//                }];
//            }
//            else if (weakself.scannerType == YDScannerTypeQRVE_BOX
//                     && [typeCode isEqualToString:@"01"]){
//                //只限VE-BOX
//                [UIAlertController YD_OK_AlertController:self title:@"当前只可扫描VE-BOX" message:nil clickBlock:^{
//                    [weakself.scanVC startQRCodeReading];
//                }];
//            }
//            else if (weakself.scannerType == YDScannerTypeQRVE_Air
//                     && ![typeCode isEqualToString:@"01"]){
//                //只限VE-BOX
//                [UIAlertController YD_OK_AlertController:self title:@"当前只可扫描VE-Air" message:nil clickBlock:^{
//                    [weakself.scanVC startQRCodeReading];
//                }];
//            }
//            else{
//                [weakself.navigationController popViewControllerAnimated:NO];
//                YDBindDeviceController *bindVC = [YDBindDeviceController new];
//                bindVC.deviceType = [typeCode isEqualToString:@"01"] ? YDBindDeviceTypeVE_AIR : YDBindDeviceTypeVE_BOX;
//                bindVC.carInfo = self.carInfo;
//                bindVC.obd_imei = imei;
//                bindVC.obd_authCode = authCode;
//                NSDictionary *param = @{
//                                        @"obd_IMEI":YDNoNilString(imei),
//                                        @"obd_pin":YDNoNilString(authCode)
//                                        };
//                [YDLoadingHUD showLoading];
//                [YDNetworking requestOBDInvitationCodeWithParamters:param complation:^(NSString *invitationCode) {
//                    
//                    bindVC.invitationCode = invitationCode;
//                    [[rootVC navigationController] pushViewController:bindVC animated:YES];
//                }];
//            }
//            
//        } isHttpBlock:^(NSString *url) {
//            [weakself.scanVC stopQRCodeReading];
//            [weakself.navigationController popViewControllerAnimated:NO];
//            YDWebController *webVC = [YDWebController new];
//            webVC.url = url;
//            [[rootVC navigationController] pushViewController:webVC animated:YES];
//        } isUnknownBlock:^(NSString *text) {
//            [weakself.scanVC stopQRCodeReading];
//            [UIAlertController YD_OK_AlertController:self title:@"未知扫描结果" message:text clickBlock:^{
//                
//            }];
//        }];
    }
}

#pragma mark - Getters
- (YDScannerController *)scanVC{
    if (_scanVC == nil) {
        _scanVC = [YDScannerController new];
        [_scanVC setDelegate:self];
    }
    return _scanVC;
}

@end

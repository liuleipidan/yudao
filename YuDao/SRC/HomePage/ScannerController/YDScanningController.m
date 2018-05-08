//
//  YDScanningController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDScanningController.h"
#import "YDWebController.h"
#import "YDScannerButton.h"
#import "YDUserFilesController.h"
#import "YDBindDeviceController.h"

/// 国际化
#define     LOCSTR(str)                 NSLocalizedString(str, nil)

@interface YDScanningController ()<YDScannerControllerDelegate>

@property (nonatomic, assign) YDScannerType currentType;

@property (nonatomic, strong) UIBarButtonItem *albumBarButton;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) YDScannerButton *userButton;

@property (nonatomic, strong) YDScannerButton *deviceButton;

@end

@implementation YDScanningController

//处理扫描完的字符串
+ (void)handleScannerString:(NSString *)text
                isUserBlock:(void (^)(NSNumber *userId))isUserBlock
              isDeviceBlock:(void (^)(NSString *imei,NSString *authCode))isDeviceBlock
                isHttpBlock:(void (^)(NSString *url))isHttpBlock
             isUnknownBlock:(void (^)(NSString *text))isUnknownBlock{
    if ([text hasPrefix:@"http"]) {
        NSRange range = [text rangeOfString:@"&&&"];
        //本App用户
        if (range.length == 3) {//解出了用户id
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
        NSRange range = [text rangeOfString:@"#"];
        if (range.length == 1) {
            NSString *xlCode = [text substringWithRange:NSMakeRange(0, range.location)];
            NSString *yzCode = [text substringFromIndex:range.location+range.length];
            if (isDeviceBlock) {
                isDeviceBlock(xlCode,yzCode);
            }
        }
        else{
            if (isUnknownBlock) {
                isUnknownBlock(text);
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"二维码"];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.scanVC.view];
    [self addChildViewController:self.scanVC];
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView yd_addSubviews:@[self.userButton,self.deviceButton]];
    
    [self sc_addMasonry];
    
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem itemWithImage:@"scanner_icon_light" target:self action:@selector(sc_lightItemAction:)]];
}

#pragma mark - Public Methods
- (void)setDisableFunctionBar:(BOOL)disableFunctionBar{
    _disableFunctionBar = disableFunctionBar;
    [self.bottomView setHidden:disableFunctionBar];
}

- (void)setDisableMoreButton:(BOOL)disableMoreButton{
    [self.scanVC setDisableMoreButton:disableMoreButton];
}

- (void)initScannerType:(YDScannerType)type{
    self.currentType = type;
}

#pragma mark - Events
//切换扫描模式
- (void)sc_scannerButtonAction:(YDScannerButton *)sender{
    if (sender.isSelected) {
        if (![self.scanVC isRunning]) {
            [self.scanVC startQRCodeReading];
        }
        return;
    }
    self.currentType = sender.type;
    
    [self.userButton setSelected:self.userButton.type == sender.type];
    [self.deviceButton setSelected:self.deviceButton.type == sender.type];
    
    [self.scanVC setScannerType:sender.type];
}

//开启／关闭照明
- (void)sc_lightItemAction:(UIBarButtonItem *)sender{
    [self.scanVC turnOffOrOnTheLight:NO];
}

#pragma mark - YDScannerControllerDelegate
- (void)scannerControllerInitSuccess:(YDScannerController *)controller{
    //第一次进来
    if (self.currentType == 0) {
        [self sc_scannerButtonAction:self.userButton];
    }
    else{
        [self sc_scannerButtonAction:self.currentType == self.userButton.type ? self.userButton : self.deviceButton];
    }
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
    
    [self sc_handleScanCompletionText:string];
}

//点击更多
- (void)scannerController:(YDScannerController *)controller clickMoreButton:(UIButton *)sender{

}

#pragma mark - Private Methods
- (void)sc_handleScanCompletionText:(NSString *)text{
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
        [YDScanningController handleScannerString:text isUserBlock:^(NSNumber *userId) {
            if (weakself.currentType == YDScannerTypeQRUser) {
                [self.scanVC stopQRCodeReading];
                [weakself.navigationController popViewControllerAnimated:NO];
                YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:userId];
                YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
                [[rootVC navigationController] pushViewController:userVC animated:YES];
            }
            else{
                //只限用户
                [UIAlertController YD_OK_AlertController:self title:@"扫描结果" message:text clickBlock:^{
                    //[self.scanVC startQRCodeReading];
                }];
            }
        } isDeviceBlock:^(NSString *imei, NSString *authCode) {
            if (weakself.currentType == YDScannerTypeQRDevice) {
                [self.scanVC stopQRCodeReading];
                [weakself.navigationController popViewControllerAnimated:NO];
                YDBindDeviceController *bindVC = [YDBindDeviceController new];
                //bindVC.ug_id = weakself.ug_id;
                bindVC.obd_imei = imei;
                bindVC.obd_authCode = authCode;
                NSDictionary *param = @{
                                        @"obd_IMEI":YDNoNilString(imei),
                                        @"obd_pin":YDNoNilString(authCode)
                                        };
                [YDLoadingHUD showLoading];
                [YDNetworking requestOBDInvitationCodeWithParamters:param complation:^(NSString *invitationCode) {
                    
                    bindVC.invitationCode = invitationCode;
                    [[rootVC navigationController] pushViewController:bindVC animated:YES];
                }];
            }
            else{
                //只限设备
                [UIAlertController YD_OK_AlertController:self title:@"扫描结果" message:text clickBlock:^{
                    
                }];
            }
        } isHttpBlock:^(NSString *url) {
            [self.scanVC stopQRCodeReading];
            [weakself.navigationController popViewControllerAnimated:NO];
            YDWebController *webVC = [YDWebController new];
            webVC.url = url;
            [[rootVC navigationController] pushViewController:webVC animated:YES];
        } isUnknownBlock:^(NSString *text) {
            [UIAlertController YD_OK_AlertController:self title:@"扫面结果" message:text clickBlock:^{
                
            }];
        }];
    }
}

- (void)sc_addMasonry{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(75);
    }];
    
    [self.userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(100));
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];
    
    [self.deviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kWidth(100));
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];
    
}

#pragma mark - Getters
- (YDScannerController *)scanVC{
    if (_scanVC == nil) {
        _scanVC = [YDScannerController new];
        [_scanVC setDelegate:self];
    }
    return _scanVC;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [UIView new];
        UIView *backView = [UIView new];
        backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_bottomView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomView);
        }];
    }
    return _bottomView;
}

- (YDScannerButton *)userButton{
    if (_userButton == nil) {
        _userButton = [[YDScannerButton alloc] initWithType:YDScannerTypeQRUser title:@"添加好友" iconPath:@"scanner_user_normal" iconHLPath:@"scanner_user_highlight"];
        [_userButton addTarget:self action:@selector(sc_scannerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userButton;
}

- (YDScannerButton *)deviceButton{
    if (_deviceButton == nil) {
        _deviceButton = [[YDScannerButton alloc] initWithType:YDScannerTypeQRDevice title:@"绑定设备" iconPath:@"scanner_device_normal" iconHLPath:@"scanner_device_highlight"];
        [_deviceButton addTarget:self action:@selector(sc_scannerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deviceButton;
}

@end

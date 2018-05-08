//
//  YDCarInfoController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/17.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarInfoController.h"
#import "YDCarInfoTableView.h"
#import "YDScannerViewController.h"
#import "YDUnbindOBDController.h"
#import "YDCarAuthenticateController.h"
#import "YDBindDeviceController.h"
#import "NSString+RegularExpressionConfig.h"

@interface YDCarInfoController ()

@property (nonatomic, strong) YDCarInfoTableView *tableView;

@property (nonatomic, strong) UIButton *authButton;

@property (nonatomic, strong) UIButton *bindButton;

@end

@implementation YDCarInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"车辆信息"];
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem itemWithTitle:@"完成" target:self action:@selector(ci_rightBarButtonItemAction:)]];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView yd_addSubviews:@[self.authButton,self.bindButton]];
    
    [self ci_handleBindButtonAndAuthButtonByCarInfo];
    
    [[YDCarHelper sharedHelper] syncServerCarInformation:self.carInfo.ug_id success:^(YDCarDetailModel *newCar){
        [self setCarInfo:newCar];
        NSLog(@"车辆同步服务器数据成功");
    } failure:^{
        NSLog(@"车辆同步服务器数据失败");
    }];
}

#pragma mark - Events
- (void)ci_rightBarButtonItemAction:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    self.carInfo.ug_plate_title = self.tableView.plate_number_header;
    self.carInfo.ug_plate = self.tableView.plate_number;
    self.carInfo.ug_frame_number = self.tableView.frame_number;
    self.carInfo.ug_engine = self.tableView.engine_number;
    self.carInfo.ug_annual_inspection = self.tableView.inspect_time ? @(YDTimeStamp(self.tableView.inspect_time).integerValue) : nil;
    self.carInfo.ug_maintenance = self.tableView.maintain_time ? @(YDTimeStamp(self.tableView.maintain_time).integerValue) : nil;
    self.carInfo.ug_status = @((int)self.tableView.isDefault);
    
    if (self.carInfo.ug_plate.length > 0 && ![self.carInfo.ug_plate re_validatePlateNumber]) {
        [YDMBPTool showInfoImageWithMessage:@"车牌号格式错误" hideBlock:nil];
        return;
    }
    
    NSMutableDictionary *paramer = self.carInfo.mj_keyValues;
    [paramer setObject:YDAccess_token forKey:@"access_token"];
    //表示认证状态
    NSInteger auth = self.carInfo.ug_vehicle_auth.integerValue;
    if (auth == 1 || auth == 2) {
        [paramer setObject:@1 forKey:@"up"];
    }
    else if(auth == 0 || auth == 3){
        [paramer setObject:@0 forKey:@"up"];
    }
    [YDLoadingHUD showLoading];
    //上传到服务器
    [YDNetworking POST:kChangeCarDataURL parameters:paramer success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            //修改数据库信息
            if ([self.carInfo.ug_status isEqual:@1]) {
                [[YDCarHelper sharedHelper] setDefaultCar:self.carInfo];
            }
            else{
                [[YDCarHelper sharedHelper] insertOneCar:self.carInfo];
            }
            
            [YDMBPTool showSuccessImageWithMessage:@"修改成功" hideBlock:^{
                if ([self.navigationController findViewController:@"YDGarageViewController"]) {
                    [self.navigationController popToViewControllerWithClassName:@"YDGarageViewController" animated:YES];
                }
                else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        else{
            [YDMBPTool showErrorImageWithMessage:YDNoNilString(status) hideBlock:nil];
            YDLog(@"code = %@",code);
        }
    } failure:^(NSError *error) {
        [YDMBPTool showErrorImageWithMessage:@"修改车辆信息失败" hideBlock:nil];
        YDLog(@"修改车辆信息失败 error = %@",error);
    }];
}

- (void)ci_authButtonAction:(UIButton *)sender{
    YDCarAuthenticateController *vc = [YDCarAuthenticateController new];
    [vc setCarInfo:self.carInfo];
    YDWeakSelf(self);
    [vc setDidUploadNewImagesBlock:^{
        YDCarDetailModel *car = [[YDCarHelper sharedHelper] getOneCarWithCarid:weakself.carInfo.ug_id];
        weakself.carInfo.ug_vehicle_auth = car.ug_vehicle_auth;
        [weakself.authButton setTitle:car.vehicle_authStatus forState:0];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ci_bindButtonAction:(UIButton *)sender{
    YDScannerViewController *scanVC = [YDScannerViewController new];
    [scanVC setCarInfo:self.carInfo];
    
    [self.navigationController pushViewController:scanVC animated:YES];
    
    //关闭自动处理
    scanVC.disableAutoHandle = YES;
    
    YDWeakSelf(self);
    YDWeakSelf(scanVC);
    [scanVC setScannerCompletionBlock:^(NSString *text) {
        [YDScannerViewController handleScannerString:text isUserBlock:^(NSNumber *userId) {
            [weakscanVC handlecanningResult_User];
        } isDeviceBlock:^(NSString *imei, NSString *authCode, NSString *typeCode) {
            if (weakscanVC.scannerType == YDScannerTypeQRVE_BOX
                && [typeCode isEqualToString:@"01"]){
                [YDMBPTool showInfoImageWithMessage:@"当前只可扫描VE-BOX" hideBlock:nil];
            }
            else if (weakscanVC.scannerType == YDScannerTypeQRVE_Air
                     && ![typeCode isEqualToString:@"01"]){
                [YDMBPTool showInfoImageWithMessage:@"当前只可扫描VE-AIR" hideBlock:nil];
            }
            else{
                YDBindDeviceController *bindVC = [YDBindDeviceController new];
                bindVC.carInfo = weakself.carInfo;
                bindVC.obd_imei = imei;
                bindVC.obd_authCode = authCode;
                NSDictionary *param = @{
                                        @"obd_IMEI":YDNoNilString(imei),
                                        @"obd_pin":YDNoNilString(authCode)
                                        };
                [YDLoadingHUD showLoading];
                [YDNetworking requestOBDInvitationCodeWithParamters:param complation:^(NSString *invitationCode) {
                    
                    bindVC.invitationCode = invitationCode;
                    [[weakself navigationController] pushViewController:bindVC animated:YES];
                }];
            }
        } isHttpBlock:^(NSString *url) {
            [weakscanVC handlecanningResult_Http];
        } isUnknownBlock:^(NSString *text) {
            [YDMBPTool showInfoImageWithMessage:@"未知扫描结果" hideBlock:nil];
        }];
    }];
}

#pragma mark - Private Methods
- (void)ci_handleBindButtonAndAuthButtonByCarInfo{
    
    //是否隐藏绑定按钮
    self.bindButton.hidden = (self.carInfo.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR);
    if (self.carInfo.boundDeviceType == YDCarBoundDeviceTypeVE_AIR) {
        [self.bindButton setTitle:@"绑定VE-BOX" forState:0];
    }
    else if (self.carInfo.boundDeviceType == YDCarBoundDeviceTypeVE_BOX){
        [self.bindButton setTitle:@"绑定VE-AIR" forState:0];
    }
    else if (self.carInfo.boundDeviceType == YDCarBoundDeviceTypeNone){
        [self.bindButton setTitle:@"绑定设备" forState:0];
    }
    
    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.width.mas_equalTo(kWidth(309));
        CGFloat bottomOffset = SCREEN_HEIGHT - (STATUSBAR_HEIGHT + NAVBAR_HEIGHT) - 20;
        make.bottom.equalTo(self.tableView).offset(IS_IPHONE5 ? bottomOffset + 10 : bottomOffset);
        make.height.mas_equalTo(kHeight(44));
    }];
    
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.size.mas_equalTo(CGSizeMake(kWidth(309),kHeight(44)));
        
        if ([self.carInfo.ug_boundtype isEqual:@1]) {
            make.bottom.equalTo(self.bindButton.mas_bottom);
        }
        else{
            make.bottom.equalTo(self.bindButton.mas_top).offset(-10);
        }
    }];
}


#pragma mark - Setter
- (void)setCarInfo:(YDCarDetailModel *)carInfo{
    if (carInfo == nil) {
        return;
    }
    _carInfo = carInfo;
    
    NSArray *data = [YDCarInfoItem createItemsByCarInfo:carInfo isAddCar:NO];
    [self.tableView setData:data title:carInfo.ug_series_name isDefault:[carInfo.ug_status isEqual:@1] ? YES : NO];
    
    [self.authButton setTitle:carInfo.vehicle_authStatus forState:0];
}

#pragma mark - Getter
- (YDCarInfoTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDCarInfoTableView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (UIButton *)authButton{
    if (_authButton == nil) {
        _authButton = [YDUIKit buttonWithTitle:@"我要认证" titleColor:[UIColor whiteColor] backgroundColor:YDBaseColor selector:@selector(ci_authButtonAction:)  target:self];
        _authButton.layer.cornerRadius = 8.0f;
    }
    return _authButton;
}

- (UIButton *)bindButton{
    if (_bindButton == nil) {
        _bindButton = [YDUIKit buttonWithTitle:@"绑定VE-BOX" titleColor:YDBaseColor backgroundColor:[UIColor whiteColor] selector:@selector(ci_bindButtonAction:)  target:self];
        _bindButton.layer.cornerRadius = 8.0f;
        _bindButton.layer.borderColor = YDBaseColor.CGColor;
        _bindButton.layer.borderWidth = 1.0;
    }
    return _bindButton;
}

@end

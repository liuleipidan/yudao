//
//  YDBindDeviceController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDBindDeviceController.h"
#import "YDBindDeviceCell.h"
#import "YDScannerViewController.h"
#import "YDBindSuccessController.h"
#import "YDSelectCarTableView.h"
#import "YDPopupController.h"
#import "YDCarBrandController.h"
#import "YDHomePageManager.h"
#import "NSString+RegularExpressionConfig.h"

#define kBindDeviceURL [kOriginalURL stringByAppendingString:@"bounddevice"]

@interface YDBindDeviceController ()<YDBindDeviceCellDelegate>

@property (nonatomic, strong) NSArray<YDBindDevice *> *data;

@property (nonatomic, strong) UIButton *defaultButton;

@property (nonatomic, strong) UIButton *bindButton;

/**
 请求邀请码的请求任务
 */
@property (nonatomic, strong) NSURLSessionDataTask *invitaionTask;

@property (nonatomic, strong) YDPopupController *popupController;

@property (nonatomic, strong) UIView *noCarView;

@property (nonatomic, strong) UIButton *addCarButton;

@end

@implementation YDBindDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bd_initUI];
    
    //添加添加新车通知
    [YDNotificationCenter addObserver:self selector:@selector(bd_hadAddedNewCarNotification:) name:kHadAddedNewCarNotification object:nil];
}

#pragma mark - Public Methods

- (void)setCarInfo:(YDCarDetailModel *)carInfo{
    _carInfo = carInfo;
    YDBindDevice *item0 = [self.data objectAtIndex:0];
    item0.subTitle = carInfo.ug_series_name;
}

- (void)setObd_imei:(NSString *)obd_imei{
    _obd_imei = obd_imei;
    YDBindDevice *item1 = [self.data objectAtIndex:1];
    item1.subTitle = obd_imei;
}

- (void)setObd_authCode:(NSString *)obd_authCode{
    _obd_authCode = obd_authCode;
    YDBindDevice *item2 = [self.data objectAtIndex:2];
    item2.subTitle = obd_authCode;
}

- (void)setInvitationCode:(NSString *)invitationCode{
    _invitationCode = invitationCode;
    YDBindDevice *item3 = [self.data objectAtIndex:3];
    item3.subTitle = invitationCode;
}

- (void)setRecommend:(NSString *)recommend{
    _recommend = recommend;
    YDBindDevice *item4 = [self.data objectAtIndex:4];
    item4.subTitle = recommend;
}

#pragma mark - Private Methods
- (void)bd_initUI{
    [self.navigationItem setTitle:@"绑定设备"];
    
    [self.tableView setRowHeight:52.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerClass:[YDBindDeviceCell class] forCellReuseIdentifier:@"YDBindDeviceCell"];
    
    [self.tableView addSubview:self.bindButton];
    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.size.mas_equalTo(CGSizeMake(kWidth(309),kHeight(44)));
        CGFloat bottomOffset = SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-25;
        make.bottom.equalTo(self.tableView).offset(IS_IPHONE5 ? bottomOffset + 10 : bottomOffset);
    }];
    
    self.tableView.tableFooterView = ({
        UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [view addSubview:self.defaultButton];
        view;
    });
}

//绑定
- (void)bd_bindButtonAction:(UIButton *)sender{
    if (self.carInfo.ug_id == nil || [self.carInfo.ug_id isEqual:@0]) {
        [YDMBPTool showInfoImageWithMessage:@"车辆不可为空" hideBlock:nil];
        return;
    }
    else if (self.obd_imei.length == 0) {
        [YDMBPTool showInfoImageWithMessage:@"VE-BOX设备序列号不可为空" hideBlock:nil];
        return;
    }
    else if (self.obd_authCode.length == 0) {
        #pragma mark - 为适配老设备验证码可为空
        //[YDMBPTool showInfoImageWithMessage:@"VE-BOX设备序列号不可为空" hideBlock:nil];
        //return;
    }
    else if (self.invitationCode.length > 0 && ![self.invitationCode re_validateInvitaionNumber]){
        [YDMBPTool showInfoImageWithMessage:@"邀请码格式错误" hideBlock:nil];
        return;
    }
    else if (self.recommend.length > 0 && self.recommend.length < 11){
        [YDMBPTool showInfoImageWithMessage:@"推荐人格式错误" hideBlock:nil];
        return;
    }
    NSDictionary *param = @{
                            @"access_token":YDAccess_token,
                            @"ug_id":self.carInfo.ug_id,
                            @"imei":self.obd_imei,
                            @"pin":self.obd_authCode.length == 4 ? self.obd_authCode : @"",
                            @"type":[self.obd_imei re_validateDeviceIMei_VE_AIR] ? @2 : @1,
                            @"invitatoin_code":YDNoNilString(self.invitationCode),
                            @"recommender":YDNoNilString(self.recommend),
                            @"ug_status":self.defaultButton.isSelected ? @1 : @0
                            };
    
    //取消邀请码请求任务
    [self.invitaionTask cancel];
    [YDLoadingHUD showLoadingInView:self.view];
    
    [YDNetworking POST:kBindDeviceURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"data = %@",param);
        if ([code isEqual:@200]) {
            if ([self.obd_imei re_validateDeviceIMei_VE_AIR]) {
                self.carInfo.ug_bind_air = @1;
            }
            else{
                self.carInfo.ug_boundtype = @1;
            }
            self.carInfo.bo_imei = self.obd_imei;
            
            if (self.defaultButton.isSelected) {
                self.carInfo.ug_status = @1;
                [[YDCarHelper sharedHelper] setDefaultCar:self.carInfo];
            }
            else{
                [[YDCarHelper sharedHelper] insertOneCar:self.carInfo];
            }
            //同步服务器信息，目前主要是为了同步channelid(渠道id)
            [[YDCarHelper sharedHelper] syncServerCarInformation:self.carInfo.ug_id success:^(YDCarDetailModel *newCar) {
                YDLog(@"车辆同步服务器数据成功 channelid = %@",newCar.channelid);
            } failure:nil];
            
            //修改用户等级
            YDUser *user = [YDUserDefault defaultUser].user;
            user.ub_auth_grade = @5;
            [YDUserDefault defaultUser].user = user;
            YDBindSuccessController *successVC = [YDBindSuccessController new];
            successVC.presentingVC = self;
            YDNavigationController *navi = [[YDNavigationController alloc] initWithRootViewController:successVC];
            [self presentViewController:navi animated:YES completion:^{
                [[YDHomePageManager manager] reloadDataSourceCompletion:nil];
            }];
        }
        else{
            [YDMBPTool showText:status.length == 0 ? @"绑定失败" : status];
        }
    } failure:^(NSError *error) {
        YDLog(@"error = %@",error);
        [YDMBPTool showErrorImageWithMessage:@"绑定失败" hideBlock:nil];
    }];
}

//请求设备邀请码
- (void)bd_requestInvitatoinCode{
    NSDictionary *param = @{
                            @"obd_IMEI":YDNoNilString(self.obd_imei),
                            @"obd_pin":YDNoNilString(self.obd_authCode)
                            };
    YDWeakSelf(self);
    self.invitaionTask = [YDNetworking requestOBDInvitationCodeWithParamters:param complation:^(NSString *invitationCode) {
        [weakself setInvitationCode:invitationCode];
        if (invitationCode.length > 0) {
            [weakself.tableView reloadData];
        }
    }];;
}

//添加了新车辆的回调
- (void)bd_hadAddedNewCarNotification:(NSNotification *)noti{
    if (noti.object) {
        self.carInfo = [[YDCarHelper sharedHelper] getOneCarWithCarid:[noti.object ug_id]];
        [self.tableView reloadData];
    }
}

//默认
- (void)bd_defaultButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

//添加新车辆
- (void)bd_addNerCarButtonAction:(UIButton *)sender{
    [_popupController dismissPopupControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[YDCarBrandController new] animated:YES];
    });
}

//展示选择车辆
- (void)bd_showSelectCarTableViewBy:(NSArray *)data canAddCar:(BOOL)canAddCar{
    YDSelectCarTableView *table = [[YDSelectCarTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 0)];
    [table reloadData:data selectedCar:self.carInfo];
    
    YDWeakSelf(self);
    [table setDidSelectedCarBlock:^(YDCarDetailModel *item) {
        [weakself.popupController dismissPopupControllerAnimated:YES];
        if (item) {
            [weakself setCarInfo:item];
            [weakself.tableView reloadData];
        }
    }];
    
    NSMutableArray *showViews = [NSMutableArray arrayWithObjects:table, nil];
    if (canAddCar) {
        [showViews addObject:self.addCarButton];
    }
    
    if ([YDCarHelper sharedHelper].carArray.count == 0) {
        [showViews insertObject:self.noCarView atIndex:0];
    }
    
    //弹出控制器
    _popupController = [[YDPopupController alloc] initWithContents:showViews];
    _popupController.theme = [YDPopupTheme defaultTheme];
    _popupController.theme.popupStyle = YDPopupStyleCentered;
    _popupController.theme.cornerRadius = 8.0f;
    
    [_popupController presentPopupControllerAnimated:YES];
}

#pragma mark - YDBindDeviceCellDelegate
//去扫一扫
- (void)bindDeviceCell:(YDBindDeviceCell *)cell didTouchScannerButton:(UIButton *)btn{
    [self.view endEditing:YES];
    
    YDScannerViewController *scanVC = [YDScannerViewController new];
    [scanVC setScannerType:YDScannerTypeQRDevice];
    [scanVC setCarInfo:self.carInfo];
    scanVC.disableMoreButton = YES;
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
                [weakself setObd_imei:imei];
                [weakself setObd_authCode:authCode];
                [weakself.tableView reloadData];
                NSDictionary *param = @{
                                        @"obd_IMEI":YDNoNilString(imei),
                                        @"obd_pin":YDNoNilString(authCode)
                                        };
                [YDLoadingHUD showLoading];
                [YDNetworking requestOBDInvitationCodeWithParamters:param complation:^(NSString *invitationCode) {
                    [weakself setInvitationCode:invitationCode];
                    if (invitationCode.length > 0) {
                        [weakself.tableView reloadData];
                    }
                }];
            }
        } isHttpBlock:^(NSString *url) {
            [weakscanVC handlecanningResult_Http];
        } isUnknownBlock:^(NSString *text) {
            [YDMBPTool showInfoImageWithMessage:@"未知扫描结果" hideBlock:nil];
        }];
    }];
}
//输入内容改变
- (void)bindDeviceCell:(YDBindDeviceCell *)cell textFieldTextDidChange:(NSString *)text{
    NSString *title = cell.item.title;
    if ([title isEqualToString:@"序列号"]) {
        self.obd_imei = text;
        if (self.obd_imei.length > 0 && self.obd_authCode.length == 4) {
            [self bd_requestInvitatoinCode];
        }
    }
    else if ([title isEqualToString:@"验证码"]){
        self.obd_authCode = text;
        if (self.obd_imei.length > 0 && self.obd_authCode.length == 4) {
            [self bd_requestInvitatoinCode];
        }
    }
    else if ([title isEqualToString:@"推荐人"]){
        self.recommend = text;
    }
    else if ([title isEqualToString:@"邀请码"]){
        [self setInvitationCode:text];
    }
}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data ? self.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDBindDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDBindDeviceCell"];
    
    [cell setItem:self.data[indexPath.row]];
    [cell setDelegate:self];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YDBindDevice *item = self.data[indexPath.row];
    if ([item.title isEqualToString:@"选择车辆"]) {
        [self.view endEditing:YES];
        
        YDWeakSelf(self);
        [[YDCarHelper sharedHelper] filterUnboundDeviceCars:^(BOOL allCarHadBind, NSArray *cars, BOOL canAdd) {
            if (allCarHadBind) {
                [YDMBPTool showInfoImageWithMessage:@"已添加两辆车且都绑定VE-BOX" hideBlock:nil];
            }
            else{
                //弹出选择视图
                [weakself bd_showSelectCarTableViewBy:cars canAddCar:canAdd];
            }
        }];
    }
}

#pragma mark - UIScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //[self.view endEditing:YES];
    
}

#pragma mark - Getter
- (NSArray<YDBindDevice *> *)data{
    if (_data == nil) {
        _data = [YDBindDevice bindDeviceItemByCar:self.carInfo deviceType:self.deviceType];
    }
    return _data;
}

- (UIButton *)defaultButton{
    if (_defaultButton == nil) {
        _defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultButton setImage:@"bindOBD_defaultCar_normal" imageSelected:@"bindOBD_defaultCar_selected"];
        [_defaultButton setTitle:@"设为默认车辆" forState:0];
        [_defaultButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:7];
        [_defaultButton setTitleColor:[UIColor blackTextColor] forState:0];
        _defaultButton.frame = CGRectMake(10, 10, 120, 30);
        [_defaultButton.titleLabel setFont:[UIFont font_12]];
        
        [_defaultButton addTarget:self action:@selector(bd_defaultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultButton;
}

- (UIButton *)bindButton{
    if (_bindButton == nil) {
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindButton setTitle:@"绑定" forState:0];
        [_bindButton setTitleColor:[UIColor whiteColor] forState:0];
        [_bindButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _bindButton.backgroundColor = [UIColor baseColor];
        _bindButton.layer.cornerRadius = 8.0f;
        
        [_bindButton addTarget:self action:@selector(bd_bindButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindButton;
}

- (UIButton *)addCarButton{
    if (_addCarButton == nil) {
        _addCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addCarButton setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forState:0];
        
        [_addCarButton setTitle:@"绑定新车辆" forState:0];
        [_addCarButton setTitleColor:[UIColor whiteColor] forState:0];
        [_addCarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_addCarButton.titleLabel setFont:[UIFont font_16]];
        [_addCarButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 52.0f)];
        
        [_addCarButton addTarget:self action:@selector(bd_addNerCarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addCarButton;
}

- (UIView *)noCarView{
    if (_noCarView == nil) {
        _noCarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 138.0f)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackTextColor] forState:0];
        [button setTitle:@"目前暂无车辆" forState:0];
        [button.titleLabel setFont:[UIFont font_16]];
        [button setImage:YDImage(@"bingOBD_detail_noCar") forState:0];
        [button setFrame:CGRectMake(0, 0, 100, 60)];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:15];
        [_noCarView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.noCarView);
            make.size.mas_equalTo(CGSizeMake(100, 60));
        }];
    }
    return _noCarView;
}

@end

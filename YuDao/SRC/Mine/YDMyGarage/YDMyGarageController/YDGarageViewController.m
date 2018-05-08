//
//  YDGarageViewController.m
//  YuDao
//
//  Created by 汪杰 on 16/10/14.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDGarageViewController.h"
#import "YDGaragesCell.h"
#import "YDCarBrandController.h"
#import "YDCarAuthenticateController.h"
#import "YDCarHelper.h"
#import "YDScannerViewController.h"
#import "YDCarIllegalityController.h"
#import "YDCarInfoController.h"
#import "YDBindDeviceController.h"

@interface YDGarageViewController ()<YDGaragesCellDelegate>

@property (nonatomic, strong) NSMutableArray<YDCarDetailModel *> *data;

//车库无车辆提示
@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation YDGarageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车库";
    
    self.tableView.rowHeight = 150.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YDGaragesCell class] forCellReuseIdentifier:@"YDGaragesCell"];
    
    self.tableView.mj_header = [YDRefreshTool yd_MJheaderTarget:self action:@selector(synServerGarageData)];
    
    [self.tableView setTableFooterView:self.footerLabel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.data = [[YDCarHelper sharedHelper] limitCarsCount];
    if (self.data.count == 0) {
        self.footerLabel.text = @"车库现在空空如也，快来添加爱车吧";
    }
    else{
        self.footerLabel.text = @"";
    }
    [self.tableView reloadData];
    
}

/**
 同步服务器车库数据
 */
- (void)synServerGarageData{
    YDWeakSelf(self);
    [YDNetworking GET:kCarsListURL parameters:@{@"access_token":YDAccess_token} success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            [[YDCarHelper sharedHelper] insertCars:[YDCarDetailModel mj_objectArrayWithKeyValuesArray:data]];
            weakself.data = [[YDCarHelper sharedHelper] limitCarsCount];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - YDGaragesCellDelegate
//MARK:点击单元格里的button
- (void)garagesCell:(YDGaragesCell *)cell didTouchButton:(UIButton *)sender{
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"车辆认证"]) {
        YDCarAuthenticateController *vc = [YDCarAuthenticateController new];
        [vc setCarInfo:cell.model];
        YDWeakSelf(self);
        [vc setDidUploadNewImagesBlock:^{
            weakself.data = [NSMutableArray arrayWithArray:[YDCarHelper sharedHelper].carArray];
            [weakself.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"违章查询"]){
        YDCarIllegalityController *carIllegal = [YDCarIllegalityController new];
        [carIllegal setUg_id:cell.model.ug_id];
        [self.navigationController pushViewController:carIllegal animated:YES];
    }
    else if ([title isEqualToString:@"绑定设备"] ||
             [title isEqualToString:@"绑定VE-AIR"] ||
             [title isEqualToString:@"绑定VE-BOX"]){
        YDScannerViewController *scanVC = [YDScannerViewController new];
        [scanVC setCarInfo:cell.model];
        
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
                    bindVC.carInfo = cell.model;
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
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.data.count == kShowCarsCount) {
        return self.data.count;
    }
    return self.data? self.data.count + 1: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDGaragesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDGaragesCell"];
    cell.delegate = self;
    if (indexPath.row == _data.count && _data.count < kShowCarsCount) {
        return [self setAddCellWithTableView:tableView];
    }
    else{
        cell.model = self.data[indexPath.row];
        YDWeakSelf(self);
        [cell setGaragesCellDeleteCarBlock:^(YDCarDetailModel *model) {
            if (model.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR) {
                [YDMBPTool showInfoImageWithMessage:@"请先解绑VE-BOX和VE-AIR" hideBlock:nil];
            }
            else if (model.boundDeviceType == YDCarBoundDeviceTypeVE_BOX){
                [YDMBPTool showInfoImageWithMessage:@"请先解绑VE-BOX" hideBlock:nil];
            }
            else if (model.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
                [YDMBPTool showInfoImageWithMessage:@"请先解绑VE-AIR" hideBlock:nil];
            }
            else{
                [LPActionSheet showActionSheetWithTitle:@"确认删除此车辆？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
                    if (index == -1) {
                        [YDMBPTool showText:@"删除中"];
                        [weakself deleteCar:model];
                    }
                }];
            }
        }];
    }
    return cell;
}
//创建添加车里按钮
- (UITableViewCell *)setAddCellWithTableView:(UITableView *)tableView{
    UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
    if (addCell == nil) {
        addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
        addCell.selectionStyle = 0;
        UIImageView *addImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_auth_backImage"]];
        [addCell.contentView addSubview:addImageV];
        UIButton *addBtn = [YDUIKit buttonWithImage:[UIImage imageNamed:@"mine_auth_add"] selectedImage:[UIImage imageNamed:@"mine_auth_add"] selector:nil target:nil];
        [addImageV addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(addImageV);
            make.width.height.mas_equalTo(42);
        }];
        [addImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(addCell.contentView).insets(UIEdgeInsetsMake(7, 9, 7, 9));
        }];
    }
    return addCell;
}

//MARK:删除车辆
- (void)deleteCar:(YDCarDetailModel *)car{
    YDWeakSelf(self);
    NSDictionary *param = @{
                            @"access_token":YDAccess_token,
                            @"ug_id":car.ug_id
                            };
    [YDNetworking POST:kDeleteCar parameters:param success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            [_data enumerateObjectsUsingBlock:^(YDCarDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YDCarDetailModel *model = obj;
                if ([model.ug_id isEqual:car.ug_id]) {
                    [_data removeObjectAtIndex:idx];
                    [[YDCarHelper sharedHelper] deleteOneCar:car];
                    [weakself.tableView reloadData];
                    *stop = YES;
                }
            }];
            
        }
        else if ([code isEqual:@9024]){
            [YDMBPTool showInfoImageWithMessage:@"请先解绑VE-BOX" hideBlock:nil];
        }
        else{
            [YDMBPTool showErrorImageWithMessage:@"删除车辆失败" hideBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击添加车辆
    if (indexPath.row == _data.count && _data.count < kShowCarsCount) {
        if (self.data.count >= kShowCarsCount) {
            [UIAlertController YD_OK_AlertController:self title:@"最多添加五辆车" clickBlock:nil];
        }
        else{
            [self.navigationController pushViewController:[YDCarBrandController new] animated:YES];
        }
    }
    else{
        YDCarDetailModel *model = self.data[indexPath.row];
        YDCarInfoController *messageVC = [YDCarInfoController new];
        messageVC.carInfo = model;
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

- (UILabel *)footerLabel{
    if (_footerLabel == nil) {
        _footerLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
        _footerLabel.text = @"";
        _footerLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    }
    return _footerLabel;
}

@end

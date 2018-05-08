//
//  YDAddCarController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/17.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDAddCarController.h"
#import "YDCarInfoTableView.h"
#import "NSString+RegularExpressionConfig.h"

#define kAddCarInfoURL [kOriginalURL stringByAppendingString:@"addvehicle"]

@interface YDAddCarController ()

@property (nonatomic, strong) YDCarInfoTableView *tableView;

@end

@implementation YDAddCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"添加车辆"];
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem itemWithTitle:@"完成" target:self action:@selector(ac_rightBarButtonItemAction:)]];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)ac_rightBarButtonItemAction:(UIBarButtonItem *)sender{
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
    [YDLoadingHUD showLoading];
    
    [YDNetworking POST:kAddCarInfoURL parameters:paramer success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            self.carInfo.ug_id = [data objectForKey:@"ug_id"];
            self.carInfo.ug_brand_logo = [data objectForKey:@"ug_brand_logo"];
            if ([self.carInfo.ug_status isEqual:@1]) {
                [[YDCarHelper sharedHelper] setDefaultCar:self.carInfo];
            }
            else{
                [[YDCarHelper sharedHelper] insertOneCar:self.carInfo];
            }
            
            //通知已经添加了新车辆
            [YDNotificationCenter postNotificationName:kHadAddedNewCarNotification object:self.carInfo];
            
            [YDMBPTool showSuccessImageWithMessage:@"添加车辆成功" hideBlock:^{
                if ([self.navigationController findViewController:@"YDGarageViewController"]) {
                    [self.navigationController popToViewControllerWithClassName:@"YDGarageViewController" animated:YES];
                }
                else if ([self.navigationController findViewController:@"YDBindDeviceController"]){
                    [self.navigationController popToViewControllerWithClassName:@"YDBindDeviceController" animated:YES];
                }
            }];
        }
        else{
            [YDMBPTool showErrorImageWithMessage:@"添加车辆失败" hideBlock:nil];
            YDLog(@"status = %@",status);
        }
    } failure:^(NSError *error) {
        [YDMBPTool showErrorImageWithMessage:@"添加车辆失败" hideBlock:nil];
    }];
}

- (void)setCarInfo:(YDCarDetailModel *)carInfo{
    if (carInfo == nil) {
        return;
    }
    _carInfo = carInfo;
    
    NSArray *data = [YDCarInfoItem createItemsByCarInfo:carInfo isAddCar:YES];
    [self.tableView setData:data title:carInfo.ug_series_name isDefault:[YDCarHelper sharedHelper].carArray.count == 0 ? YES : NO];
}

#pragma mark - Getter
- (YDCarInfoTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[YDCarInfoTableView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

@end

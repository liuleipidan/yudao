//
//  YDTrafficInfoController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 16/12/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDTrafficInfoController+Delegate.h"
#import "YDCarDetailModel.h"
#import "YDLocationMapController.h"
#import "YDPopBlurViewManager.h"
#import "YDRankListViewController.h"

@implementation YDTrafficInfoController (Delegate)

#pragma mark - YDTrafficInfoManagerDelegate
- (void)trafficInfoManager:(YDTrafficInfoManager *)manager currentCarDidChanged:(YDCarDetailModel *)currentCar{
    YDLog();
    if (currentCar == nil) {
        self.carLocView.carChooseLabel.text = @"暂无车辆";
        [self.carLocView.carIcon setImage:nil forState:0];
        return;
    }
    
    //UI
    if (currentCar.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR ||
        currentCar.boundDeviceType == YDCarBoundDeviceTypeVE_BOX) {
        self.titleLabel.text = @"当前车况";
    }
    else if (currentCar.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        self.titleLabel.text = @"空气质量";
    }
    
    self.carLocView.carChooseLabel.text = currentCar.ug_brand_name;
    [self.carLocView.carIcon yd_setImage:currentCar.ug_brand_logo placeholderImage:nil];
    [self.carInfoView updateUIByTrafficInfoManager:manager];
    
    //Data
    [self requestTrafficInfo];
    
    //开启蓝牙
    if (self.infoManager.currentCar.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR ||
        self.infoManager.currentCar.boundDeviceType == YDCarBoundDeviceTypeVE_AIR) {
        
        [[YDBluetoothManager manager] setCurrentCar:self.infoManager.currentCar];
    }
}

- (void)trafficInfoManager:(YDTrafficInfoManager *)manager requestCarDataCompletion:(NSNumber *)code{
    if ([code isEqual:@200]) {
        [self.carInfoView updateDataByTrafficInfoManager:manager];
        
        [self.carLocView updateRankingByTrafficInfoManager:manager];
        
        if (manager.currentCar.boundDeviceType != YDCarBoundDeviceTypeVE_AIR) {
            [self.carInfoView setScore:manager.score];
        }
    }
    
    YDLog();
}


#pragma mark  - YDCarInfoViewDelegate
//点击分数
- (void)carInfoViewClickTest{
    YDTestsController *testVC = [YDTestsController new];
    testVC.car = [[YDCarHelper sharedHelper] getOneCarWithCarid:_infoManager.currentCar.ug_id];
    [self.parentViewController.navigationController pushViewController:testVC animated:YES];
}
//点击里程
- (void)carInfoViewClickMileage{
    
}
//点击油耗
- (void)carInfoViewClickOilwear{
    
}

#pragma mark - YDCarHelperDelegate
//下载完所有车辆
- (void)carHelperLoginRequestGarageComplation{
    //设置当前车辆
    [self.infoManager setCurrentCar:[YDCarHelper sharedHelper].defaultCar];
}
//默认车辆改变
- (void)carHelperDefaultCarHadChanged:(YDCarDetailModel *)defCar{
    //设置当前车辆
    [self.infoManager setCurrentCar:defCar];
}
//车辆绑定状态改变
- (void)carHelperCarBoundTypeDidChanged:(YDCarDetailModel *)changedCar{
    if ([changedCar.ug_id isEqual:self.infoManager.currentCar.ug_id]) {
        [self.infoManager setCurrentCar:changedCar];
    }
}

#pragma mark - YDCarsLocationViewDelegate
//MARK:点击车辆选择试图
- (void)carsLocationView:(YDCarsLocationView *)view didClickedSwitchWithFrame:(CGRect)frame{
    
    if ([YDCarHelper sharedHelper].carArray.count == 0) {
        [YDMBPTool showInfoImageWithMessage:@"暂无车辆" hideBlock:nil];
        return;
    }
    
    NSArray *cars = [YDCarHelper sharedHelper].carArray;
    __block NSInteger index = 0;
    [cars enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YDCarDetailModel *car = obj;
        if ([car.ug_id isEqual:self.infoManager.currentCar.ug_id]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    self.tableView = [[YDPopTableView alloc] initWithDataSource:cars selectedIndex:index];
    CGRect initFrame = [view convertRect:frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect tableFrame = CGRectMake(initFrame.origin.x,initFrame.origin.y,SCREEN_WIDTH-20, cars.count * self.tableView.rowHeight);
    [self.tableView setFrame:tableFrame];
    
    YDWeakSelf(self);
    [self.tableView setSelectedCarBlock:^(YDCarDetailModel *model){
        
        [weakself.infoManager setCurrentCar:model];
        
        weakself.tableView = nil;
        [YDPopBlurViewManager dismiss];
    }];
    [YDPopBlurViewManager showBlurViewWithContentView:self.tableView initFrame:initFrame blurAlpha:20 type:YDPopBlurTypeSpring];
}
//MARK:点击里程排行
- (void)carsLocationViewDidTouchRank{
    YDRankListViewController *rankListVC = [[YDRankListViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:rankListVC animated:YES];
}

//MARK:点击定位按钮
- (void)carsLocationView:(YDCarsLocationView *)view didTouchLocationBtn:(UIButton *)locBtn{
    YDLocationMapController *lmVC =  [YDLocationMapController new];
    lmVC.currentCarId = _infoManager.currentCar.ug_id;
    [self.parentViewController.navigationController pushViewController:lmVC animated:YES];
    
}

@end

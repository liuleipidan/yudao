//
//  YDTestsController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestsController+Delegate.h"
#import "YDCarIllegalityController.h"

@implementation YDTestsController (Delegate)

- (void)registerCells{
    
    [self.tableView registerClass:[YDTestCuringCell class] forCellReuseIdentifier:@"YDTestCuringCell"];
    [self.tableView registerClass:[YDTestOilCell class] forCellReuseIdentifier:@"YDTestOilCell"];
    [self.tableView registerClass:[YDTestOtherDataCell class] forCellReuseIdentifier:@"YDTestOtherDataCell"];
    [self.tableView registerClass:[YDTestIllegalCell class] forCellReuseIdentifier:@"YDTestIllegalCell"];
    [self.tableView registerClass:[YDTestCodeCell class] forCellReuseIdentifier:@"YDTestCodeCell"];
    [self.tableView registerClass:[YDTestAQICell class] forCellReuseIdentifier:@"YDTestAQICell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - YDTestCellDelegate
- (void)testAQICellDidClickedBuyVe_AIR:(YDTestAQICell *)cell{
    NSString *url = self.car.testModel.veAirMallLinkUrl;
    if (url == 0) {
        return;
    }
    YDWKWebViewController *wkVC = [[YDWKWebViewController alloc] init];
    [wkVC setUrlString:url];
    [self.navigationController pushViewController:wkVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSUInteger rows = 0;
    if (self.car.boundDeviceType == YDCarBoundDeviceTypeVE_BOX ||
        self.car.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR) {
        rows = 6;
    }
    else if (self.car.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        rows = 2;
    }
    return self.car.testModel ? rows : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YDTestCell *cell;
    if (self.car.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR ||
        self.car.boundDeviceType == YDCarBoundDeviceTypeVE_BOX ) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestCuringCell"];
        }
        else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestOilCell"];
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestAQICell"];
            [cell setDelegate:self];
            
            YDTestAQICell *aqiCell = (YDTestAQICell *)cell;
            [aqiCell setState:[self.car.ug_bind_air isEqual:@1] ? YDTestAQICellStateBound : YDTestAQICellStateUnbound];
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestIllegalCell"];
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestCodeCell"];
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestOtherDataCell"];
        }
    }
    else if (self.car.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestAQICell"];
            [cell setDelegate:self];
            
            YDTestAQICell *aqiCell = (YDTestAQICell *)cell;
            [aqiCell setState:[self.car.ug_bind_air isEqual:@1] ? YDTestAQICellStateBound : YDTestAQICellStateUnbound];
        }
        else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"YDTestIllegalCell"];
        }
    }
    else{
        return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
    }
    
    [cell setModel:self.car.testModel];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.car.cellHeightDic valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDTestCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titleLabel.text isEqualToString:@"车辆违章"]) {
        YDCarIllegalityController *carIllegal = [YDCarIllegalityController new];
        [carIllegal setUg_id:self.car.ug_id];
        [self.navigationController pushViewController:carIllegal animated:YES];
    }
}

@end

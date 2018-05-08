//
//  YDBluetoothManager.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/11.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDBluetoothDataModel.h"

@class CBPeripheral;
@interface YDBluetoothManager : NSObject

//外设
@property (nonatomic, strong) CBPeripheral *peripheral;

//当前需要连接设备的车辆
@property (nonatomic, weak  ) YDCarDetailModel *currentCar;

+ (YDBluetoothManager *)manager;

- (void)startScanPeripheral;

- (void)stopScanPeripheral;



@end

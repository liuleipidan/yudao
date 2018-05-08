//
//  YDBluetoothConfig.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/18.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDBluetoothConfig_h
#define YDBluetoothConfig_h

//外设名
static NSString *const kPeripheralName = @"Car_Air";

//基础的UUID,16位
static NSString *const kBase_UUID = @"6E40%@-B5A3-F393-E0A9-E50E24DCCA9E";

//服务UUID
static NSString *const kServceUUID = @"0001";

//特征UUID<Wirte>
static NSString *const kCharacteristicsUUID_Wirte = @"0002";

//特征UUID<Nofity>
static NSString *const kCharacteristicsUUID_Nofity = @"0003";

//数据读取频率/s
static NSTimeInterval const kReadDataInterval = 5;

//蓝牙状态监测频率
static NSTimeInterval const kBluetoothObserveInterval = 0.2;

//蓝牙状态
typedef NS_ENUM(NSInteger, YDBluetoothState){
    YDBluetoothStateUnknown = 0,
    YDBluetoothStatePoweredOff,
    YDBluetoothStatePoweredOn,
    YDBluetoothStateScaning,
    YDBluetoothStateScanSuccess,
    YDBluetoothStateConnecting,
    YDBluetoothStateConnected,
    YDBluetoothStateDisconnect,
};

#pragma mark - 广播用到Key
//蓝牙状态改变
static NSString *const kBluetoothStateChangedKey = @"kBluetoothStateChangedKey";
//蓝牙数据
static NSString *const kVE_AIR_DataKey = @"kVE_AIR_DataKey";

#endif /* YDBluetoothConfig_h */

//
//  YDBluetoothManager.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/11.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDBluetoothManager.h"
#import "YDBluetoothConfig.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CBPeripheral+YuDao.h"

@interface YDBluetoothManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

//中心设备管理
@property (nonatomic, strong) CBCentralManager *centralManager;

//特征1(notify)
@property (nonatomic, strong) CBCharacteristic *notifyCharacteristic;

//特征2(write)
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;

//蓝牙状态
@property (nonatomic, assign) YDBluetoothState bluetoothState;


@end


@implementation YDBluetoothManager
{
    NSTimer *_stateTimer;
    NSTimer *_dataTimer;
}

+ (YDBluetoothManager *)manager{
    static dispatch_once_t onceToken;
    static YDBluetoothManager *bluetoothManager;
    dispatch_once(&onceToken, ^{
        bluetoothManager = [[YDBluetoothManager alloc] init];
    });
    return bluetoothManager;
}

- (id)init{
    if (self = [super init]) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
        _centralManager.delegate = self;
        
        self.bluetoothState = YDBluetoothStateUnknown;
        
        //监听bluetoothState
        [self addObserver:self forKeyPath:@"bluetoothState" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"bluetoothState"];
}

#pragma mark - Public Methods
- (void)setCurrentCar:(YDCarDetailModel *)currentCar{
    _currentCar = currentCar;
    
    if (currentCar.boundDeviceType != YDCarBoundDeviceTypeBOX_AIR &&
        currentCar.boundDeviceType != YDCarBoundDeviceTypeVE_AIR) {
        [self btm_stopBluetooth];
        return;
    }
    
    NSString *peripheralMac = currentCar.air_mac;
    NSString *peripheralIdentifier = currentCar.air_identifier;
    if (peripheralMac.length == 0) {
        [self stopScanPeripheral];
        return;
    }
    
    if ([_peripheral.macAddress isEqualToString:peripheralMac] &&
        _peripheral.state == CBPeripheralStateConnected) {
        return;
    }
    _peripheral = nil;
    self.bluetoothState = _centralManager.state == CBManagerStatePoweredOn ? YDBluetoothStatePoweredOn : YDBluetoothStatePoweredOff;
    
    if (_centralManager.state != CBManagerStatePoweredOn) {
        [self btm_startTimerToObserveBluetoothAuthrizationState];
        return;
    }
    //优先查询已知设备
    if (peripheralIdentifier.length > 0) {
        NSUUID *knownId = [[NSUUID alloc] initWithUUIDString:peripheralIdentifier];
        NSArray<CBPeripheral *> *knownPeripherals = [_centralManager retrievePeripheralsWithIdentifiers:@[knownId]];
        __block CBPeripheral *peripheral = nil;
        [knownPeripherals enumerateObjectsUsingBlock:^(CBPeripheral * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.identifier.UUIDString isEqualToString:peripheralIdentifier]) {
                peripheral = obj;
                *stop = YES;
            }
        }];
        if (peripheral) {
            _peripheral = peripheral;
            _peripheral.macAddress = currentCar.air_mac;
            [_centralManager connectPeripheral:_peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey : @YES}];
        }
    }
    //查询已连接设备
    if (_peripheral == nil) {
        CBUUID *VE_AIRServiceUUID = [CBUUID UUIDWithString:[NSString stringWithFormat:kBase_UUID,kServceUUID]];
        NSArray<CBPeripheral *> *connectedPeripherals = [_centralManager retrieveConnectedPeripheralsWithServices:@[VE_AIRServiceUUID]];
        __block CBPeripheral *peripheral = nil;
        [connectedPeripherals enumerateObjectsUsingBlock:^(CBPeripheral * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.identifier.UUIDString isEqualToString:peripheralIdentifier]) {
                peripheral = obj;
                *stop = YES;
            }
        }];
        if (peripheral) {
            _peripheral = peripheral;
            _peripheral.macAddress = currentCar.air_mac;
            [_centralManager connectPeripheral:_peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey : @YES}];
        }
    }
    
    //扫描设备
    if (_peripheral == nil) {
        [self startScanPeripheral];
    }
}

//开始扫描
- (void)startScanPeripheral{
    [_centralManager scanForPeripheralsWithServices:nil options:@{
                                                                  CBCentralManagerScanOptionAllowDuplicatesKey: @NO
                                                                  }];
    self.bluetoothState = YDBluetoothStateScaning;
    
    if (_stateTimer) {
        [_stateTimer invalidate];
        _stateTimer = nil;
    }
}

//停止扫描
- (void)stopScanPeripheral{
    if (_centralManager.isScanning) {
        [_centralManager stopScan];
    }
    
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"bluetoothState"]) {
        YDLog(@"self.bluetoothState = %ld",self.bluetoothState);
        [YDNotificationCenter postNotificationName:kBluetoothStateChangedKey object:@(self.bluetoothState)];
    }
}

#pragma mark - Private Methods
//停止扫描、断开连接
- (void)btm_stopBluetooth{
    if (_centralManager.isScanning) {
        [_centralManager stopScan];
    }
    if (_peripheral) {
        [_centralManager cancelPeripheralConnection:_peripheral];
    }
}
//读取数据
- (void)btm_repeatWitreDataToBlueTooth{
    if (_peripheral.state != CBPeripheralStateConnected) {
        return;
    }
    //开启监听
    //[_peripheral setNotifyValue:YES forCharacteristic:_notifyCharacteristic];
    
    //发送消息
    [_peripheral writeValue:[YDBluetoothDataModel air_sendGetDataBao] forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
    //读取数据
    //[_peripheral readValueForCharacteristic:_characteristic];
}
//监听蓝牙状态
- (void)btm_observeBluetoothAuthrizationStateChange{
    
    if (_centralManager.state == CBCentralManagerStatePoweredOn) {
        [_stateTimer invalidate];
        _stateTimer = nil;
        if (!_centralManager.isScanning) {
            [self startScanPeripheral];
        }
    }
    else if (   _centralManager.state == CBManagerStateResetting
             || _centralManager.state == CBManagerStateUnauthorized
             || _centralManager.state == CBManagerStatePoweredOff){
        [self stopScanPeripheral];
    }
    else{
        [_stateTimer invalidate];
        _stateTimer = nil;
    }
}

//开启定时器监听蓝牙状态
- (void)btm_startTimerToObserveBluetoothAuthrizationState{
    if (_stateTimer == nil) {
         _stateTimer = [NSTimer scheduledTimerWithTimeInterval:kBluetoothObserveInterval target:self selector:@selector(btm_observeBluetoothAuthrizationStateChange) userInfo:nil repeats:YES];
    }
}

#pragma mark - CBCentralManagerDelegate
//蓝牙状态改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:
            YDLog(@"未知");
            self.bluetoothState = YDBluetoothStatePoweredOff;
            break;
        case CBManagerStateResetting:
        {
            self.bluetoothState = YDBluetoothStatePoweredOff;
            [self btm_startTimerToObserveBluetoothAuthrizationState];
            YDLog(@"重置中，待会重试");
            break;}
        case CBManagerStateUnsupported:
        {
            self.bluetoothState = YDBluetoothStatePoweredOff;
            YDLog(@"当前设备不支持蓝牙");
            break;}
        case CBManagerStateUnauthorized:
        {
            self.bluetoothState = YDBluetoothStatePoweredOff;
            [self btm_startTimerToObserveBluetoothAuthrizationState];
            YDLog(@"初次调用蓝牙，待会重试");
            break;}
        case CBManagerStatePoweredOff:
        {
            self.bluetoothState = YDBluetoothStatePoweredOff;
            [self btm_startTimerToObserveBluetoothAuthrizationState];
            NSLog(@"蓝牙未开启，待会重试");
            break;}
        case CBManagerStatePoweredOn:
        {
            YDLog(@"蓝牙已打开");
            self.bluetoothState = YDBluetoothStatePoweredOn;
            [self startScanPeripheral];
            break;}
            
        default:
            break;
    }
}
//发现外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (peripheral == nil
        || peripheral.identifier == nil
        || peripheral.name == nil) {
        return;
    }
    YDLog(@"peripheral.name = %@",peripheral.name);
    if ([peripheral.name isEqualToString:kPeripheralName]) {
        self.bluetoothState = YDBluetoothStateScanSuccess;
        
        NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        //解出对应的外设Mac地址
        NSString *peripheralMac = [YDBluetoothDataModel air_bluetoothMacAddressVerification:data];
        
        BOOL isSame = ([peripheralMac compare:self.currentCar.air_mac options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame);
        
        if (isSame) {
            _peripheral = peripheral;
            _peripheral.macAddress = peripheralMac;
            _peripheral.delegate = self;
            [_currentCar.airInfo setObject:_peripheral.identifier.UUIDString forKey:@"air_identifier"];
            [[YDCarHelper sharedHelper] insertOneCar:_currentCar];
            [_centralManager connectPeripheral:_peripheral options:@{
                                                                     CBConnectPeripheralOptionNotifyOnConnectionKey : @YES
                                                                     }];
            self.bluetoothState = YDBluetoothStateConnecting;
            //停止扫描
            [self stopScanPeripheral];
        }
    }
}
//外设连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    YDLog(@"外设连接成功");
    
    self.bluetoothState = YDBluetoothStateConnected;
    
    [peripheral setDelegate:self];
    
    //扫面服务
    [peripheral discoverServices:nil];
    
    //停止扫描
    [self stopScanPeripheral];
}
//外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    YDLog(@"外设连接失败 : %@",error.localizedDescription);
    self.bluetoothState = YDBluetoothStateDisconnect;
    
}

#pragma mark - CBPeripheralDelegate
//发现外设的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        YDLog(@"发现服务错误 : %@",error.localizedDescription);
        return;
    }
    
    [peripheral.services enumerateObjectsUsingBlock:^(CBService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.UUID.UUIDString isEqualToString:[NSString stringWithFormat:kBase_UUID,kServceUUID]]) {
            YDLog(@"找到对应的服务");
            [peripheral discoverCharacteristics:nil forService:obj];
            *stop = YES;
        }
    }];
    
}

//发现服务的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error{
    if (error) {
        YDLog(@"发现特征错误 : %@",error.localizedDescription);
        return;
    }
    
    [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.UUID.UUIDString isEqualToString:[NSString stringWithFormat:kBase_UUID,kCharacteristicsUUID_Wirte]]) {
            YDLog(@"找到写对应的特征");
            self.writeCharacteristic = obj;
        }
        else if ([obj.UUID.UUIDString isEqualToString:[NSString stringWithFormat:kBase_UUID,kCharacteristicsUUID_Nofity]]){
            YDLog(@"找到监听对应的特征");
            self.notifyCharacteristic = obj;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.notifyCharacteristic];
        }
    }];
}

//收到特征的广播
//@link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        YDLog(@"特征的广播错误 : %@",error.localizedDescription);
        return;
    }
    NSNumber *aqi = [YDBluetoothDataModel air_bluetoothDataVerification:characteristic.value];
    if (aqi) {
        [YDNotificationCenter postNotificationName:kVE_AIR_DataKey object:aqi];
    }
    
}

//@link writeValue:forCharacteristic:type:
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    if (error) {
        YDLog(@"Write Value Error : %@",error.localizedDescription);
        return;
    }
    YDLog(@"收到 写入返回 --------- 特征数据：%@",characteristic.value);
}

////@link setNotifyValue:forCharacteristic:
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        NSLog(@"Update Notification State Error : %@",error.localizedDescription);
        return;
    }
    YDLog(@"收到通知状态改变 --------- isNotifying = %d",characteristic.isNotifying);
    if (characteristic.isNotifying) {
        [self btm_repeatWitreDataToBlueTooth];
        if (_dataTimer) {
            [_dataTimer invalidate];
            _dataTimer = nil;
        }
        _dataTimer = [NSTimer scheduledTimerWithTimeInterval:kReadDataInterval target:self selector:@selector(btm_repeatWitreDataToBlueTooth) userInfo:nil repeats:YES];
    }

}

@end

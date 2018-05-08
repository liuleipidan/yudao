//
//  CBPeripheral+YuDao.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/28.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (YuDao)

@property (nonatomic, copy  ) NSString *macAddress;

@end

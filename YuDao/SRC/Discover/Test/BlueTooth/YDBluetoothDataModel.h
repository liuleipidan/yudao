//
//  YDBluetoothDataModel.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/28.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDBluetoothDataModel : NSObject

+ (NSString *)VE_AIR_AQIGrade:(NSInteger)aqi;

+ (NSString *)VE_AIR_AQIGradeLong:(NSInteger)aqi;

+ (NSData *)air_sendGetDataBao;

+ (NSNumber *)air_bluetoothDataVerification:(NSData *)data;

+ (NSString *)air_bluetoothMacAddressVerification:(NSData *)data;

@end

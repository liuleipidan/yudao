//
//  YDBluetoothDataModel.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/28.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDBluetoothDataModel.h"

@implementation YDBluetoothDataModel

+ (NSString *)VE_AIR_AQIGrade:(NSInteger)aqi{
    if (aqi >= 500) {
        aqi = 400;
    }
    NSString *indexString = @"";
    if (aqi <= 50) {
        indexString = @"优";
    }
    else if (aqi > 50 && aqi <= 100){
        indexString = @"良";
    }
    else if (aqi > 100 && aqi <= 150){
        indexString = @"轻度";
    }
    else if (aqi > 150 && aqi <= 200){
        indexString = @"中度";
    }
    else if (aqi > 200 && aqi <= 300){
        indexString = @"重度";
    }
    else if (aqi > 300 && aqi <= 500){
        indexString = @"极度";
    }
    return indexString;
}

+ (NSString *)VE_AIR_AQIGradeLong:(NSInteger)aqi{
    //限制最高
    if (aqi >= 500) {
        aqi = 400;
    }
    NSString *indexString = @"";
    NSString *indexImagePath = @"test_AQI_index1";
    if (aqi <= 50) {
        indexString = @"优";
        indexImagePath = @"test_AQI_index1";
    }
    else if (aqi > 50 && aqi <= 100){
        indexString = @"良";
        indexImagePath = @"test_AQI_index2";
    }
    else if (aqi > 100 && aqi <= 150){
        indexString = @"轻度污染";
        indexImagePath = @"test_AQI_index3";
    }
    else if (aqi > 150 && aqi <= 200){
        indexString = @"中度污染";
        indexImagePath = @"test_AQI_index4";
    }
    else if (aqi > 200 && aqi <= 300){
        indexString = @"重度污染";
        indexImagePath = @"test_AQI_index5";
    }
    else if (aqi > 300 && aqi <= 500){
        indexString = @"极度污染";
        indexImagePath = @"test_AQI_index6";
    }
    return indexString;
}

//发送获取数据的包
+ (NSData *)air_sendGetDataBao{
    //55 01 01 02
    Byte reg[4];
    reg[0]=0x55;
    reg[1]=0x01;
    reg[2]=0x01;
    reg[3]=0x02;
    NSData *data=[NSData dataWithBytes:reg length:4];
    return data;
}

//数据校验
+ (NSNumber *)air_bluetoothDataVerification:(NSData *)data{
    Byte *byte = (Byte *)[data bytes];
    if (data.length == 5) {
        if (byte[4] == (byte[0]^byte[1]^byte[2]^byte[3])) {
            Byte reg[2];
            reg[0] = byte[2];
            reg[1] = byte[3];
            NSData *resultData = [NSData dataWithBytes:reg length:2];
            NSString *hexStr = [NSString coverFromDataToHexStr:resultData];
            UInt64 aqi =  strtoul([hexStr UTF8String], 0, 16);
            return @(aqi);
        }
    }
    return nil;
}
//解析Mac地址
+ (NSString *)air_bluetoothMacAddressVerification:(NSData *)data{
    if (data == nil || data.length != 8) {
        return nil;
    }
    Byte *byte = (Byte *)[data bytes];
    NSMutableArray *macArr = [NSMutableArray array];
    for (int i = 2; i < [data length]; i++) {
        NSString *str = [NSString stringWithFormat:@"%02x",(byte[i])&0xff];
        [macArr addObject:str];
    }
    if (macArr.count == 6) {
        return [macArr componentsJoinedByString:@":"];
    }
    return nil;
}

@end

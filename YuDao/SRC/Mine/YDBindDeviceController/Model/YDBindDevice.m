//
//  YDBindDevice.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDBindDevice.h"

@implementation YDBindDevice

+ (YDBindDevice *)createBindDevice:(YDBindDeviceCellType )type
                             title:(NSString *)title
                       placeholder:(NSString *)placeholder{
    YDBindDevice *item = [YDBindDevice new];
    item.type = type;
    item.title = title;
    item.placeholder = placeholder;
    
    return item;
}

+ (NSArray *)bindDeviceItemByCar:(YDCarDetailModel *)car
                      deviceType:(YDBindDeviceType)deviceType{
    YDBindDevice *item0 = [self createBindDevice:YDBindDeviceCellTypeArrow title:@"选择车辆" placeholder:@"请选择已有车辆或绑定新车辆"];
    item0.rightImagePath = @"bingOBD_detail_rightArrow";
    if (car) {
        item0.subTitle = car.ug_series_name;
    }
    
    YDBindDevice *item1 = [self createBindDevice:YDBindDeviceCellTypeScanner title:@"序列号" placeholder:@"请输入设备上的序列号"];
    item1.rightImagePath = @"bingOBD_detail_sm";
    item1.textFieldLimit = 20;
    
    YDBindDevice *item2 = [self createBindDevice:YDBindDeviceCellTypeNone title:@"验证码" placeholder:@"请输入VE-BOX上的验证码"];
    item2.textFieldLimit = 4;
    
    if (deviceType == YDBindDeviceTypeVE_BOX) {
        [item1 setPlaceholder:@"请输入VE-BOX上的序列号"];
        [item2 setPlaceholder:@"请输入VE-BOX上的验证码"];
    }
    else if (deviceType == YDBindDeviceTypeVE_AIR){
        [item1 setPlaceholder:@"请输入VE-AIR上的序列号"];
        [item2 setPlaceholder:@"请输入VE-AIR上的验证码"];
    }
    
    YDBindDevice *item3 = [self createBindDevice:YDBindDeviceCellTypeNone title:@"邀请码" placeholder:@"绑定后不可更改(6位)"];
    item3.textFieldLimit = 6;
    
    YDBindDevice *item4 = [self createBindDevice:YDBindDeviceCellTypeNone title:@"推荐人" placeholder:@"手机号(非必填)"];
    item4.textFieldLimit = 11;
    
    return @[item0,item1,item2,item3,item4];
}

@end

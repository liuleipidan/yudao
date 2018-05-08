//
//  YDTestsModel.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDIllegalModel.h"

@interface YDTestsModel : NSObject

//车辆信息
@property (nonatomic,weak) YDCarDetailModel *carInfo;

//健康分数
@property (nonatomic, strong) NSNumber *ug_health;

//三个月里程
@property (nonatomic, strong) NSNumber *mileage;

//平均油耗
@property (nonatomic, strong) NSNumber *avg_fuel;

//OBD是否运行中
@property (nonatomic, strong) NSNumber *isopen;

//蓄电池电压
@property (nonatomic, strong) NSNumber *voltage;

//养护
@property (nonatomic, strong) NSNumber *percent;

//冷却液温度
@property (nonatomic, strong) NSNumber *coolanttemp;

//错误码
@property (nonatomic, strong) NSNumber *faultcode;

//VE-AIR的商城链接
@property (nonatomic, copy  ) NSString *veAirMallLinkUrl;

//违章数据
@property (nonatomic, strong) NSArray<YDIllegalModel *> *illegalArray;

#pragma mark - UI

@property (nonatomic, strong) NSString *faultString;

#pragma mark - 废弃
//未知
@property (nonatomic, strong) NSNumber *oilmass;

//未知
@property (nonatomic, strong) NSNumber *vehiclesafety;

//是否安全驾驶，0否，1是
@property (nonatomic, strong) NSNumber *safedriving;

//是否显示胎压数据，0关，1开
@property (nonatomic, strong) NSNumber *tirepressure;

@end

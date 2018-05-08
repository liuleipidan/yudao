//
//  YDCarDetailModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDCarDetailModel : NSObject

+ (YDCarDetailModel *)ranklistCreatModel:(NSString *)imageName title:(NSString *)title slectedIndex:(NSInteger )index;


//车辆icon
@property (nonatomic, copy  ) NSString *ug_brand_logo;

@property (nonatomic, copy  ) NSString *ug_positive;//行驶证正面

@property (nonatomic, copy  ) NSString *ug_negative;//行驶证反面

@property (nonatomic, copy  ) NSString *bo_imei;    //OBD_imei

@property (nonatomic, copy  ) NSNumber *ug_province;

@property (nonatomic, copy  ) NSString *ug_province_name;

@property (nonatomic, copy  ) NSNumber *ug_city;

@property (nonatomic, copy  ) NSString *ug_city_name;

/**
 * 认证参数( 0 -> 未认证, 1 -> 认证成功, 2 -> 认证中, 3 -> 认证失败)
 */
@property (nonatomic, strong) NSNumber *ug_vehicle_auth;

//认证状态字符串
@property (nonatomic, copy  ) NSString *vehicle_authStatus;

/**
 *  是否为默认车辆(0 -> 非默认,  1 -> 默认)
 */
@property (nonatomic, strong) NSNumber *ug_status;

/**
 *  是否绑定OBD(0 -> 未绑定,  1 -> 已绑定)
 */
@property (nonatomic, strong) NSNumber *ug_boundtype;

/**
 *  已经绑定的设备类型
 */
@property (nonatomic, assign, readonly) YDCarBoundDeviceType boundDeviceType;

/**
 *  车牌头
 */
@property (nonatomic, copy  ) NSString *ug_plate_title;
/**
 *  车牌号
 */
@property (nonatomic, copy  ) NSString *ug_plate;

/**
 *  车架号
 */
@property (nonatomic, copy  ) NSString *ug_frame_number;

/**
 *  发动机号
 */
@property (nonatomic, copy  ) NSString *ug_engine;

/**
 违章时间
 */
@property (nonatomic, strong) NSString *wz_date;

/**
 年检时间
 */
@property (nonatomic, strong) NSNumber *ug_annual_inspection;

/**
 上次保养时间
 */
@property (nonatomic, strong) NSNumber *ug_maintenance;

//渠道id（对应obd）
@property (nonatomic, strong) NSNumber *channelid;

/**
 *  车辆id
 */
@property (nonatomic, strong) NSNumber *ug_id;
//车辆对应的用户id
@property (nonatomic, strong) NSNumber *ub_id;

/**
 *  车辆品牌id、系列、型号id
 */
@property (nonatomic, strong) NSNumber *vb_id;
/**
 *  车辆车系id
 */
@property (nonatomic, strong) NSNumber *vs_id;
/**
 *  车辆车型id
 */
@property (nonatomic, strong) NSNumber *vm_id;
/**
 *  品牌名
 */
@property (nonatomic, copy  ) NSString *ug_brand_name;
/**
 *  车系名
 */
@property (nonatomic, copy  ) NSString *ug_series_name;
/**
 *  车型名
 */
@property (nonatomic, copy  ) NSString *ug_model_name;

#pragma mark - VE-AIR
/**
 *  是否绑定VE-AIR(0 -> 未绑定,  1 -> 已绑定)
 */
@property (nonatomic, strong) NSNumber *ug_bind_air;

/**
 *  VE-AIR的扩展信息
 */
@property (nonatomic, strong) NSMutableDictionary *airInfo;

/**
 *  VE-AIR渠道id
 */
@property (nonatomic, strong, readonly) NSNumber *airChannelId;

/**
 *  VE-AIR序列号
 */
@property (nonatomic, strong, readonly) NSNumber *air_imei;

/**
 *  VE-AIR蓝牙Mac地址
 */
@property (nonatomic, copy, readonly) NSString *air_mac;

/**
 *  VE-AIR蓝牙identifier(NSUUID)
 */
@property (nonatomic, copy, readonly) NSString *air_identifier;

/**
 *  VE-AIR下次清洗时间
 */
@property (nonatomic, strong, readonly) NSNumber *airNextCleaningTime;


@end

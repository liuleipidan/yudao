//
//  YDBindDeviceController.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTableViewController.h"

@interface YDBindDeviceController : YDTableViewController

/**
 要绑定的设备类型，默认是YDBindDeviceTypeUnknown
 具体参考YDBindDeviceType
 */
@property (nonatomic, assign) YDBindDeviceType deviceType;

/**
 若选择车辆过来则传，否则为nil
 */
@property (nonatomic, strong) YDCarDetailModel *carInfo;

/**
 OBD序列号
 */
@property (nonatomic, copy  ) NSString *obd_imei;

/**
 OBD验证码
 */
@property (nonatomic, copy  ) NSString *obd_authCode;

/**
 邀请码,用于捆绑渠道，由序列号和验证码获取
 */
@property (nonatomic, copy  ) NSString *invitationCode;

/**
 推荐人手机号
 */
@property (nonatomic, copy  ) NSString *recommend;

@end

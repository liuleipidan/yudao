//
//  YDRegularExpressoinConfig.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/27.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDRegularExpressoinConfig_h
#define YDRegularExpressoinConfig_h

//匹配头
static NSString *const MATCH_PREFIX = @"SELF MATCHES %@";

#pragma mark - 二维码扫描
//二维码扫描正则，二维码扫描用户资料的链接
static NSString *const SCAN_RESULT_MATCH_HTTP = @"^(http|https)://";

//二维码扫描正则，二维码扫描用户资料的正则
static NSString *const SCAN_RESULT_MATCH_USER = @"((http|https)://)[^\\s]*&&&\\d*";

//二维码扫描ve_box正则，具体如下：[公司缩写][日期编码][产品序列号]；公司缩写为YL；日期编码为4位数字，值固定为0176；产品序列号由6位数字组成，从000001至999999；
static NSString *const SCAN_RESULT_MATCH_VE_BOX = @"[a-zA-Z]{1}[0-9a-zA-Z]{11}#[0-9a-zA-Z]{4,}";

//二维码扫描ve_air正则,具体如下：[产品编号][产品序列号];产品编码由3位数字组成，101表示VE-AIR，102表示VE-SEE后续产品依此类推（VE-BOX产品例外）;产品序列号由9位数字组成，从000000001至999999999
static NSString *const SCAN_RESULT_MATCH_VE_AIR = @"101[0-9]{9}#[0-9a-zA-Z]{4,}";

#pragma mark - 设备序列号
//VE-BOX序列号正则
static NSString *const DEVICE_IMEI_VE_BOX = @"[a-zA-Z]{1}[0-9a-zA-Z]{11}";

//VE-AIR序列号正则
static NSString *const DEVICE_IMEI_VE_AIR = @"101[0-9]{9}";

//设备邀请码
static NSString *const INVITAION_NUMBER = @"([0-9a-zA-Z]{6})";

//车牌号
static NSString *const PLATE_NUMBER = @"([a-zA-Z]{1}[0-9a-zA-Z]{5,6})";

#endif /* YDRegularExpressoinConfig_h */

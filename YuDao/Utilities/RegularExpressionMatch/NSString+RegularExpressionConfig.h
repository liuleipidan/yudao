//
//  NSString+RegularExpressionConfig.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/27.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpressionConfig)


/**
 验证“扫一扫”扫描结果

 @return YDScannerResultType
 */
- (YDScannerResultType)re_validateScanResult;

/**
 验证VE-BOX序列号
 */
- (BOOL)re_validateDeviceIMei_VE_BOX;

/**
 验证VE-AIR序列号
 */
- (BOOL)re_validateDeviceIMei_VE_AIR;

/*
 * 判断是不是空字符串
 */
- (BOOL)re_validateEmptyString;

/*
 * 是否为车牌号
 */
- (BOOL)re_validatePlateNumber;
/*
 * 是否为邀请码
 */
- (BOOL)re_validateInvitaionNumber;

@end

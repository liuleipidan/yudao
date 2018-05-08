//
//  YDBindDeviceIntroductionController.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"

@interface YDBindDeviceIntroductionController : YDViewController

/**
 若选择车辆过来则传，否则为nil
 */
@property (nonatomic, strong) YDCarDetailModel *carInfo;

@end

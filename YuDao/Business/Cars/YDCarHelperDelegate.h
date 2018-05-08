//
//  YDCarHelperDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDCarDetailModel;
@protocol YDCarHelperDelegate <NSObject>

@optional
/**
 登录后请求车库数据完毕
 */
- (void)carHelperLoginRequestGarageComplation;

/**
 删除车辆
 */
- (void)carHelperDeleteCar:(YDCarDetailModel *)car;

/**
 默认车辆改变

 @param defCar 新的默认车辆
 */
- (void)carHelperDefaultCarHadChanged:(YDCarDetailModel *)defCar;

/**
 车辆绑定状态改变

 @param changedCar 状态改变后的车辆
 */
- (void)carHelperCarBoundTypeDidChanged:(YDCarDetailModel *)changedCar;

@end

//
//  YDDBCarStore.h
//  YuDao
//
//  Created by 汪杰 on 16/11/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDCarDetailModel.h"

@interface YDDBCarStore : YDDBBaseStore

/**
 *  新的车
 */
- (BOOL)insertOrUpdateCar:(YDCarDetailModel *)car;

/**
 *  获取所有的车
 *
 */
- (NSMutableArray *)getAllCars;

/**
 *  删除所有车
 *
 *  @return YES 删除成功  NO 删除失败
 */
- (BOOL)deleteAllCars;

/**
 *  删除一辆车
 *
 *  @return YES 删除成功  NO 删除失败
 */
- (BOOL)deleteOneCar:(NSNumber *)ug_id;

/**
 *  获取一辆车
 *
 */
- (YDCarDetailModel *)getOneCarWithCarid:(NSNumber *)carid;

/**
 *  获取默认车辆，可能为空
 *
 */
- (YDCarDetailModel *)getDefaultCarByUserId:(NSNumber *)userId;

/**
 *  获取绑定了obd的车辆，可能为空
 *
 */
- (YDCarDetailModel *)getBoundOBDCarByUserId:(NSNumber *)userId;

/**
 *  修改车辆的绑定OBD状态
 */
- (BOOL)updateCarOBDStatus:(NSInteger )boundStatus
                       uid:(NSNumber *)uid
                     ug_id:(NSNumber *)ug_id;

@end

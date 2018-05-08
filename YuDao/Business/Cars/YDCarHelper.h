//
//  YDCarHelper.h
//  YuDao
//
//  Created by 汪杰 on 16/11/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDCarDetailModel.h"
#import "YDDBCarStore.h"
#import "GCDMulticastDelegate.h"
#import "YDCarHelperDelegate.h"

//限制显示车辆数量
static NSUInteger const kShowCarsCount = 2;

@interface YDCarHelper : NSObject

//多播代理
@property (nonatomic, strong) GCDMulticastDelegate<YDCarHelperDelegate> *delegate;

@property (nonatomic, strong) NSMutableArray *carArray;

@property (nonatomic, strong) YDCarDetailModel *defaultCar;

+ (YDCarHelper *) sharedHelper;

+ (void)attemptDealloc;

/**
 下载车库数据

 @param access_token 用户token
 */
- (void)downloadCarsData:(NSString *)access_token;

/**
 所有车辆
 */
- (NSMutableArray *)allCars;

/**
 返回count辆车

 @return 车辆数组
 */
- (NSMutableArray *)limitCarsCount;

/**
 已经绑定了OBD的车辆
 */
- (NSArray *)hadBoundDeviceCars;

/**
 筛选未绑定车辆
 
 @param allCarHadBind 满五辆车且都绑定了VE-BOX和VE-AIR
 @param cars 有一种及以上的设备未绑定的车辆
 @param canAdd 是否可添加车辆
 */
- (void)filterUnboundDeviceCars:(void (^)(BOOL allCarHadBind,NSArray *cars,BOOL canAdd))completion;

//***********************  数据库操作  *******************************
/**
 *  获取id对应车辆
 *
 *  @param carid ug_id
 *
 *  @return 车辆详细数据
 */
- (YDCarDetailModel *)getOneCarWithCarid:(NSNumber *)carid;
/**
 *  插入一辆车
 *
 *  @param car 车
 */
- (void)insertOneCar:(YDCarDetailModel *)car;
/**
 *  插入多辆车
 *
 *  @param cars 辆车数组
 */
- (void)insertCars:(NSArray<YDCarDetailModel *> *)cars;

/**
 同步服务器车辆信息

 @param ug_id 车辆id
 */
- (void)syncServerCarInformation:(NSNumber *)ug_id
                         success:(void (^)(YDCarDetailModel *newCar))success
                         failure:(void (^)(void))failure;

//删除所有车辆
- (void)deleteAllCars;

//删除一辆车
- (void)deleteOneCar:(YDCarDetailModel *)car;

/**
 *  修改车辆的绑定OBD状态
 */
- (void)updateCarOBDStatus:(NSInteger )boundStatus
                       uid:(NSNumber *)uid
                     ug_id:(NSNumber *)ug_id;

/**
 添加代理
 */
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 移除代理
 */
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

@end

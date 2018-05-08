//
//  YDTrafficInfoManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDWeatherModel.h"

@class YDTrafficInfoManager;
@protocol YDTrafficInfoManagerDelegate <NSObject>

/**
 当前车辆发生改变

 @param manager 行车信息管理
 @param currentCar 改变后的车辆
 */
- (void)trafficInfoManager:(YDTrafficInfoManager *)manager currentCarDidChanged:(YDCarDetailModel *)currentCar;


/**
 车辆数据请求完成

 @param manager 行车信息管理
 @param code 标识码
 */
- (void)trafficInfoManager:(YDTrafficInfoManager *)manager requestCarDataCompletion:(NSNumber *)code;

@end

/**
 行车信息管理类
 */
@interface YDTrafficInfoManager : NSObject

//代理
@property (nonatomic, weak  ) id<YDTrafficInfoManagerDelegate> delegate;

/**
 当前车辆id
 */
@property (nonatomic, strong) YDCarDetailModel *currentCar;

#pragma mark - 当前车辆的绑定状态
//VE-BOX绑定状态
@property (nonatomic, assign, readonly) BOOL veBoxIsBound;
//VE-AIR绑定状态
@property (nonatomic, assign, readonly) BOOL veAirIsBound;

#pragma mark - VE-AIR相关数据
/**
 车况健康值
 */
@property (nonatomic, copy, readonly) NSString *score;

/**
 里程（本周）
 */
@property (nonatomic, copy, readonly) NSString *mileage;

/**
 油耗（本周）
 */
@property (nonatomic, copy, readonly) NSString *oilwear;

/**
 排名（昨日里程）
 */
@property (nonatomic, copy, readonly) NSString *rank;

/**
 排名状态图片字符串
 */
@property (nonatomic, copy, readonly) NSString *rankingImageStr;

#pragma mark - VE-AIR相关数据
/**
 车外AQI
 */
@property (nonatomic, copy, readonly) NSString *outsideAQI;

/**
 车内AQI
 */
@property (nonatomic, copy  ) NSString *insideAQI;

/**
 天气对象
 */
@property (nonatomic, strong) YDWeatherModel *weather;



/**
 请求车辆数据

 @param completion 完成回调
 */
- (void)requestCarDataCompletion:(void (^)(NSNumber *code,NSString *status))completion;

@end

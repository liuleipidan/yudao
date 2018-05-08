//
//  YDBiBiDataManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

///哔哔数据管理类
@interface YDBiBiDataManager : NSObject

//****************  数据  ********************
/**
 获取车辆位置

 @param carid 车辆id
 @param success 成功回调车辆坐标（已经过坐标）
 @param failure 失败
 */
+ (void)reloadCarLocation:(NSNumber *)carid
                  success:(void (^)(CLLocationCoordinate2D carCoor))success
                  failure:(void (^)(void))failure;


//****************  工具  ********************
/**
 计算两点距离
 
 @param coor1 坐标1
 @param coor2 坐标2
 @return 返回计算好的距离(>1000->xxxkm,<1000->xx.ym)
 */
+ (NSString *)metersBetweenCoordinate2D1:(CLLocationCoordinate2D )coor1
                           Coordinate2D2:(CLLocationCoordinate2D )coor2
                              completion:(void (^)(NSString *distance,BOOL walk))completion;
//计算两点距离
+ (CLLocationDistance)distanceWithCoor1:(CLLocationCoordinate2D)coor1
                                  coor2:(CLLocationCoordinate2D)coor2;

/**
 开启百度地图导航，支持app和web

 @param walk yes为步行，no为驾驶
 @param start 开始点
 @param end 结束点
 */
+ (void)openBaiduMapNavigate:(BOOL)walk
                       start:(CLLocationCoordinate2D)start
                         end:(CLLocationCoordinate2D)end;

/**
 开启高德地图导航，目前只支持app

 @param start 开始点
 @param end 结束点
 */
+ (void)openGaodeMapNavigateStart:(CLLocationCoordinate2D)start
                              end:(CLLocationCoordinate2D)end;

@end

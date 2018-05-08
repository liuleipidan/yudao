//
//  YDWeatherModel.h
//  YuDao
//
//  Created by 汪杰 on 16/12/26.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDWeatherModel : NSObject

@property (nonatomic, copy  ) NSString *provinceName;
@property (nonatomic, copy  ) NSString *cityName;

@property (nonatomic, copy  ) NSString *nowTemperature;

//当前天气码，用于取天气背景图片
@property (nonatomic, copy  ) NSString *nowWeatherCode;
//今日温度范围
@property (nonatomic, copy  ) NSString *todayTemperatureRange;
//空气质量
@property (nonatomic, copy  ) NSString *airQuality;
//空气质量指数
@property (nonatomic, strong) NSNumber *airQualityExponent;
//洗车
@property (nonatomic, copy  ) NSString *washCarDesc;
//穿衣
@property (nonatomic, copy  ) NSString *clothesDesc;
//运动
@property (nonatomic, copy  ) NSString *sportsDesc;
//旅游
@property (nonatomic, copy  ) NSString *travelDesc;

#pragma mark - UI
//当前温度
@property (nonatomic, copy  ) NSString *currentTemperature;

+ (void)requestWeatherData:(void (^)(YDWeatherModel *weather))success
                   failure:(void (^)(void))failure;



@end

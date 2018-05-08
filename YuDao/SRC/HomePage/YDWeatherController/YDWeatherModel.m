//
//  YDWeatherModel.m
//  YuDao
//
//  Created by 汪杰 on 16/12/26.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDWeatherModel.h"

@implementation YDWeatherModel

+ (void)requestWeatherData:(void (^)(YDWeatherModel *weather))success
                   failure:(void (^)(void))failure{
    NSString *tempCity = [YDUserLocation sharedLocation].userCity;
    NSString *city = nil;
    if (tempCity && tempCity.length > 0) {
        city = [tempCity substringWithRange:NSMakeRange(0, tempCity.length-1)];
    }
    NSDictionary *parameter = parameter = @{@"cityname":city ? city: @"上海"};
    [YDNetworking GET:kWeatherURL parameters:parameter success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            YDWeatherModel *weatherModel = [YDWeatherModel new];
            [weatherModel setValuesForKeysWithDictionary:data];
            if (success) {
                success(weatherModel);
            }
        }
        else{
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

#pragma mark - Getters


@end

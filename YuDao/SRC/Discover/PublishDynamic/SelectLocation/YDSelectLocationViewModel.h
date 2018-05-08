//
//  YDSelectLocationViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "YDPoiInfo.h"

@interface YDSelectLocationViewModel : NSObject

/**
 已经选择的兴趣
 */
@property (nonatomic, strong) YDPoiInfo *selectedPoi;

/**
 周边检索poi数组
 */
@property (nonatomic, strong) NSMutableArray<YDPoiInfo *> *data;

- (id)initWithUserCity:(NSString *)city
           selectedPoi:(YDPoiInfo *)selectedPoi;

/**
 检索周边

 @param userCoor 用户经纬度
 @param completion 检索完成，noData：YES,无数据
 */
- (void)searchNearbyWithUserLocation:(CLLocationCoordinate2D )userCoor
                          completion:(void (^)(BOOL noData))completion;


@end

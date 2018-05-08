//
//  YDUserLocation.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "YDPoiInfo.h"

@interface YDUserLocation : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D userCoor;
@property (nonatomic, strong) BMKUserLocation *userLocation;

/**
 当前位置更新回调
 */
@property (nonatomic,copy) void (^updateLocationBlock) (BMKUserLocation *userLocation);

+ (YDUserLocation *)sharedLocation;
+ (void)attemptDealloc;

//****************  地址信息  ********************
@property (nonatomic, copy  ) NSString *userCity;//市
@property (nonatomic, copy  ) NSString *userdistrict;//区
@property (nonatomic, copy  ) NSString *address;//地址
@property (nonatomic, copy  ) NSString *businessCircle;//所在商圈

//****************  POI数组  ********************
@property (nonatomic, strong) YDPoiInfo *selectedPoi;
@property (nonatomic, strong) NSArray *poiArray;

//****************  定位  ********************
- (void)startLocation;
- (void)stopLocation;


@end

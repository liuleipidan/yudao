//
//  YDMapSearchManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef NS_ENUM(NSInteger, YDMapSearchType) {
    YDMapSearchTypeParkingLot,
    YDMapSearchType4S,
    YDMapSearchTypeGasStation,
};

typedef void(^YDSearchCompletionBlock)(YDMapSearchType type, NSArray<BMKPoiInfo *> *list);

///百度地图搜索类
@interface YDMapSearchManager : NSObject

/**
 停车场列表
 */
@property (nonatomic, strong) NSArray<BMKPoiInfo *> *parkingLotList;

/**
 4S店列表
 */
@property (nonatomic, strong) NSArray<BMKPoiInfo *> *carStoreList;

@property (nonatomic,copy) YDSearchCompletionBlock searchCompletionBlock;

- (void)startSearchWith:(YDMapSearchType )type
               location:(CLLocationCoordinate2D )location
  searchCompletionBlock:(YDSearchCompletionBlock)block;

@end

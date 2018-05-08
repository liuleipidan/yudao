//
//  YDMapSearchManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMapSearchManager.h"

@interface YDMapSearchManager()<BMKPoiSearchDelegate>

@property (nonatomic, strong) BMKPoiSearch *poiSearch;

@property (nonatomic, assign) YDMapSearchType searchType;

@end

@implementation YDMapSearchManager

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)startSearchWith:(YDMapSearchType )type
               location:(CLLocationCoordinate2D )location
  searchCompletionBlock:(YDSearchCompletionBlock)block{
    _searchType = type;
    _searchCompletionBlock = block;
    if (!_poiSearch) {
        _poiSearch = [BMKPoiSearch new];
        _poiSearch.delegate = self;
    }
    BMKNearbySearchOption *nearSearch = [BMKNearbySearchOption new];
    nearSearch.location = location;
    nearSearch.pageIndex = 1;
    nearSearch.pageCapacity = 20;
    nearSearch.radius = 3000;
    nearSearch.sortType = BMK_POI_SORT_BY_DISTANCE;
    if (type == YDMapSearchTypeParkingLot) {
        nearSearch.keyword = @"停车场";
    }else if (type == YDMapSearchTypeGasStation){
        nearSearch.keyword = @"加油站";
    }else{
        nearSearch.keyword = @"4S店";
    }
    BOOL flag = [_poiSearch poiSearchNearBy:nearSearch];
    if (flag) {
        YDLog(@"周边搜索成功");
    }else{
        YDLog(@"周边搜索失败");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    NSLog(@"errorCode = %d",errorCode);
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        if (_searchType == YDMapSearchTypeParkingLot || _searchType == YDMapSearchTypeGasStation) {
            _parkingLotList = [NSArray arrayWithArray:poiResult.poiInfoList];
        }else{
            _carStoreList = [NSArray arrayWithArray:poiResult.poiInfoList];
        }
        if (_searchCompletionBlock) {
            _searchCompletionBlock(_searchType,poiResult.poiInfoList);
        }
    }else{
        [YDMBPTool showText:@"未检索到内容"];
    }
    [self stopSearch];
}

- (void)stopSearch{
    if (_poiSearch) {
        _poiSearch.delegate = nil;
        _poiSearch = nil;
    }
}

@end

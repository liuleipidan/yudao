//
//  YDSelectLocationViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSelectLocationViewModel.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface YDSelectLocationViewModel()<BMKPoiSearchDelegate>

@property (nonatomic, strong) BMKPoiSearch *poiSearch;

@property (nonatomic, strong) NSArray *keywords;

@property (nonatomic, assign) NSUInteger keywordIndex;

/**
 暂存检索出来的数据，用于排序
 */
@property (nonatomic, strong) NSMutableArray<YDPoiInfo *> *tempArray;

@property (nonatomic,copy) void (^completion) (BOOL noData);

@end

@implementation YDSelectLocationViewModel

- (id)initWithUserCity:(NSString *)city
           selectedPoi:(YDPoiInfo *)selectedPoi{
    if (self = [super init]) {
        _selectedPoi = selectedPoi;
        YDPoiInfo *poi = [[YDPoiInfo alloc] init];
        poi.name = @"不显示位置";
        YDPoiInfo *cityPoi = [[YDPoiInfo alloc] init];
        cityPoi.name = city ? city : @"上海";
        _data = [NSMutableArray arrayWithObjects:poi,cityPoi, nil];
        if (selectedPoi && ![selectedPoi.name isEqualToString:cityPoi.name] && ![selectedPoi.name isEqualToString:@"不显示位置"]) {
            [_data addObject:selectedPoi];
        }
        //初始化检索条件数组和索引
        _keywords = @[  @"餐饮",
                        @"小区/楼盘",
                        @"汽车服务",
                        @"购物",
                        @"休闲娱乐",
                        @"行政地标",
                        @"风景区/旅游区"];
        _keywordIndex = 0;
    }
    return self;
}

- (void)searchNearbyWithUserLocation:(CLLocationCoordinate2D )userCoor
                          completion:(void (^)(BOOL noData))completion{
    _completion = completion;
    if ([YDUserLocation sharedLocation].poiArray.count > 0) {
        //有限读取缓存内容
        for (YDPoiInfo *poi in [YDUserLocation sharedLocation].poiArray) {
            if (![poi.name isEqualToString:[YDUserLocation sharedLocation].selectedPoi.name]) {
                [_data addObject:poi];
            }
        }
        completion(NO);
    }else{
        [self searchPoiWithKeyword:[_keywords objectAtIndex:_keywordIndex]];
    }
}
/**
 开始检索
 */
- (void)searchPoiWithKeyword:(NSString *)keyword{
    if (_poiSearch == nil) {
        _poiSearch = [[BMKPoiSearch alloc]init];
        _poiSearch.delegate = self;
    }
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = [YDUserLocation sharedLocation].userCoor;
    
    option.keyword = keyword;
    option.radius = 3000;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    
    BOOL flag = [_poiSearch poiSearchNearBy:option];
    if(flag){
        //YDLog(@"周边检索发送成功");
    }
    else{
        //YDLog(@"周边检索发送失败");
    }
}

/**
  按距离排序
 */
- (NSArray *)sortPoiWithDistance:(NSMutableArray<YDPoiInfo *> *)data{
    //去重
    for (NSInteger i = 0; i < data.count; i++) {
        for (NSInteger j = i + 1; j < data.count; j++) {
            YDPoiInfo *temppoi = data[i];
            YDPoiInfo *poi = data[j];
            if ([temppoi.uid isEqual:poi.uid]) {
                [data removeObject:poi];
            }
        }
    }
    return [data sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        YDPoiInfo *poi1 = obj1;
        YDPoiInfo *poi2 = obj2;
        return [@(poi1.distance) compare:@(poi2.distance)];
    }];
}

#pragma mark --BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        if (_tempArray == nil) {
            _tempArray = [NSMutableArray array];
        }
        for (int i = 0; i < poiResult.poiInfoList.count; i++){
            BMKPoiInfo *poi = [poiResult.poiInfoList objectAtIndex:i];
            YDPoiInfo *info = [YDPoiInfo new];
            info.name = poi.name;
            info.uid = poi.uid;
            info.address = poi.address;
            info.city = poi.city;
            info.phone = poi.phone;
            info.pt = poi.pt;
            
            BMKMapPoint point1 = BMKMapPointForCoordinate(info.pt);
            BMKMapPoint point2 = BMKMapPointForCoordinate([YDUserLocation sharedLocation].userCoor);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
            info.distance = distance;
            [_tempArray addObject:info];
        }
    }
    if (_keywordIndex < _keywords.count-1) {
        _keywordIndex ++;
        [self searchPoiWithKeyword:[_keywords objectAtIndex:_keywordIndex]];
    }else{
        NSArray *sortArr = [self sortPoiWithDistance:_tempArray];
        [YDUserLocation sharedLocation].poiArray = sortArr;
        [_data addObjectsFromArray:sortArr];
        if (_completion) {
            _completion(_data.count >2 ? YES: NO);
        }
    }
    
}
@end

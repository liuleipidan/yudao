//
//  YDMapView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface YDMapView : BMKMapView

+ (instancetype)mapViewWithDelegate:(id<BMKMapViewDelegate>)delegate;

/**
 设置地图中心点，默认缩放等级18

 @param coor 坐标
 */
- (void)setMapStatusWithCoordinate:(CLLocationCoordinate2D )coor;

@end

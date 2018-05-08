//
//  YDMapView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMapView.h"

@implementation YDMapView

+ (instancetype)mapViewWithDelegate:(id<BMKMapViewDelegate>)delegate{
    YDMapView *mapView = [[YDMapView alloc] init];
    mapView.trafficEnabled = YES;
    mapView.showsUserLocation = YES;
    mapView.delegate = delegate;
    mapView.showsUserLocation = NO;
    mapView.userTrackingMode = BMKUserTrackingModeNone;
    mapView.showsUserLocation  = YES;
    mapView.isSelectedAnnotationViewFront = YES;
    
    BMKLocationViewDisplayParam *param = [BMKLocationViewDisplayParam new];
    param.isRotateAngleValid = YES;
    param.isAccuracyCircleShow = YES;
    [mapView updateLocationViewWithParam:param];
    
    return mapView;
}

- (void)setMapStatusWithCoordinate:(CLLocationCoordinate2D )coor{
    BMKMapStatus *mapStatus = [BMKMapStatus new];
    mapStatus.targetGeoPt = coor;
    mapStatus.fLevel = 18;
    [self setMapStatus:mapStatus];
    
}

@end

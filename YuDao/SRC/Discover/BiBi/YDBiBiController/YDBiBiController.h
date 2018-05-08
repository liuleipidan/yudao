//
//  YDLoveCarController.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "LLTabBar.h"
#import "YDLCSelectView.h"
#import "YDMapView.h"
#import "YDUserLocation.h"
#import "YDUserAnnotationView.h"
#import "YDPointAnnotation.h"
#import "YDBiBiDataManager.h"
#import "YDCarPaopaoView.h"
#import "YDMapSearchManager.h"
#import "YDBlurView.h"
#import "YDBiBiCollectionView.h"

@interface YDBiBiController : YDViewController
{
    LLTabBar *_tabBar;
    YDMapView *_mapView;
    YDLCSelectView *_selectedView;
    YDPointAnnotation *_userAnnotation;
    YDPointAnnotation *_carAnnotation;
    BMKAnnotationView *_selectedAnView;
    YDCarPaopaoView *_carppView;
    YDBlurView *_blurView;
    YDBiBiCollectionView *_collectionView;
    NSMutableArray<YDPointAnnotation *> *_parkingLotAnnotations;
}

/**
 标签栏
 */
@property (nonatomic, strong) LLTabBar *tabBar;

/**
 地图
 */
@property (nonatomic, strong) YDMapView *mapView;

/**
 用户、车辆及刷新的选择view
 */
@property (nonatomic, strong) YDLCSelectView *selectedView;

/**
 当前用户标注
 */
@property (nonatomic, strong) YDPointAnnotation *userAnnotation;

/**
 车辆标注
 */
@property (nonatomic, strong) YDPointAnnotation *carAnnotation;

/**
 已选择的标注视图,用于修改image
 */
@property (nonatomic, strong) BMKAnnotationView *selectedAnView;

/**
 爱车泡泡view
 */
@property (nonatomic, strong) YDCarPaopaoView *carppView;

@property (nonatomic, strong) YDBiBiCollectionView *collectionView;

@property (nonatomic, strong) YDBlurView *blurView;

@property (nonatomic, strong) NSMutableArray<YDPointAnnotation *> *parkingLotAnnotations;

@end

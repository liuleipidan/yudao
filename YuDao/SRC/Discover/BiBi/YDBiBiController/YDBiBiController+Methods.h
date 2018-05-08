//
//  YDBiBiController+Methods.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/5.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiController.h"

@interface YDBiBiController (Methods)


/**
 请求车辆位置并添加标注
 */
- (void)reloadCarLocationView;

/**
 添加停车场标注
 */
- (void)addParkingLotAnnotation;
/**
 添加加油站标注
 */
- (void)addGasStationAnnotation;
/**
 初始设置地图中心点和添加用户气泡
 
 @param userLocation 用户位置
 */
- (void)setMapCenterAndUserAnnotataion:(BMKUserLocation*)userLocation;

/**
 弹出选择导航的alertview

 @param startCoor 开始点
 @param endCoor 结束点
 @param walk 是否步行
 */
- (void)showNavigationStartCoor:(CLLocationCoordinate2D)startCoor
                        endCoor:(CLLocationCoordinate2D)endCoor
                         isWalk:(BOOL )walk;


/**
 弹出collectoinView

 @param data 数据源
 @param cellType 显示的cell类型,normal(停车场、加油站、4S店)，user(打招呼、救援)
 */
- (void)showCollectionViewWithData:(NSArray *)data cellType:(YDBiBiCollectionViewType)cellType;

@end

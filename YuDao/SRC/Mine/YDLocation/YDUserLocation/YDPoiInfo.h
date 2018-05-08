//
//  YDPoiInfo.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDPoiInfo : NSObject
///POI名称
@property (nonatomic, strong) NSString* name;
///POIuid
@property (nonatomic, strong) NSString* uid;
///POI地址
@property (nonatomic, strong) NSString* address;
///POI所在城市
@property (nonatomic, strong) NSString* city;
///POI电话号码
@property (nonatomic, strong) NSString* phone;
///POI坐标
@property (nonatomic) CLLocationCoordinate2D pt;
///POI距离
@property (nonatomic, assign) CGFloat distance;

@end

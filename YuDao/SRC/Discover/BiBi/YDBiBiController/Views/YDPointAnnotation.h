//
//  YDPointAnnotation.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

///大头针
@interface YDPointAnnotation : BMKPointAnnotation

@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *address;
@property (nonatomic, copy  ) NSString *distance;
@property (nonatomic, assign) BOOL isWalk;
@property (nonatomic, assign) NSUInteger index;

+ (YDPointAnnotation *)pointAnnotationWith:(CLLocationCoordinate2D)coor
                                     title:(NSString *)title;

@end

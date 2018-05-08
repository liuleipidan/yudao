//
//  YDPointAnnotation.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPointAnnotation.h"

@implementation YDPointAnnotation

+ (YDPointAnnotation *)pointAnnotationWith:(CLLocationCoordinate2D)coor
                                     title:(NSString *)title{
    YDPointAnnotation *pa = [[YDPointAnnotation alloc] init];
    pa.coordinate = coor;
    pa.title = title;
    return pa;
}

@end

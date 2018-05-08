//
//  YDMapTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDMapTool : NSObject


/**
 弹出选择导航

 @param preVC 弹出的控制器
 @param startCoor 开始点
 @param endCoor 结束点
 @param walk 是否步行
 */
+ (void)showNavigationPresentViewController:(UIViewController *)preVC
                                  startCoor:(CLLocationCoordinate2D)startCoor
                                    endCoor:(CLLocationCoordinate2D)endCoor
                                     isWalk:(BOOL )walk;

@end

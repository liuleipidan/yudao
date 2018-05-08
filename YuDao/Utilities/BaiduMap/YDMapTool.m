//
//  YDMapTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMapTool.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@implementation YDMapTool

/**
 弹出选择导航的alertview
 */
+ (void)showNavigationPresentViewController:(UIViewController *)preVC
                                  startCoor:(CLLocationCoordinate2D)startCoor
                                    endCoor:(CLLocationCoordinate2D)endCoor
                                     isWalk:(BOOL )walk{
    NSArray *selects = nil;
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        selects = @[@"使用百度地图",@"使用高德地图"];
    }else{
        selects = @[@"使用百度地图"];
    }
    [UIAlertController YD_alertController:preVC title:@"导航" subTitle:nil items:selects style:UIAlertControllerStyleActionSheet clickBlock:^(NSInteger index) {
        if (index == 1) {
            [YDMapTool openBaiduMapNavigate:walk start:startCoor end:endCoor];
        }else{
            [YDMapTool openGaodeMapNavigateStart:startCoor end:endCoor];
        }
    }];
}

//百度导航
+ (void)openBaiduMapNavigate:(BOOL)walk
                       start:(CLLocationCoordinate2D)start
                         end:(CLLocationCoordinate2D)end{
    BMKNaviPara *para = [BMKNaviPara new];
    BMKPlanNode *startNode = [BMKPlanNode new];
    startNode.name = @"我的位置";
    startNode.pt = start;
    BMKPlanNode *endNode = [BMKPlanNode new];
    endNode.name = @"爱车";
    endNode.pt = end;
    para.startPoint = startNode;
    para.endPoint = endNode;
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    if (walk) {
        BMKOpenErrorCode code = [BMKNavigation openBaiduMapWalkNavigation:para];
        YDLog(@"walk:openCode = %d",code);
    }else{
        BMKOpenErrorCode code = [BMKNavigation openBaiduMapNavigation:para];
        YDLog(@"openCode = %d",code);
    }
}

//高德导航
+ (void)openGaodeMapNavigateStart:(CLLocationCoordinate2D)start
                              end:(CLLocationCoordinate2D)end{
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",end.latitude,end.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:urlsting]];
    }
}

@end

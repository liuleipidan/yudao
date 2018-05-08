//
//  YDBiBiDataManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiDataManager.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@implementation YDBiBiDataManager

+ (void)reloadCarLocation:(NSNumber *)carid
                  success:(void (^)(CLLocationCoordinate2D carCoor))success
                  failure:(void (^)(void))failure{
    if (YDHadLogin) {
        NSDictionary *parameter = @{@"access_token":YDAccess_token,
                                    @"ug_id":YDNoNilNumber(carid)};
        [YDNetworking GET:kCarLocationURL parameters:parameter success:^(NSNumber *code, NSString *status, id data) {
            if ([code isEqual:@200]) {
                NSArray *location = [data objectForKey:@"loc"];
                NSNumber *latitude = location.lastObject;
                NSNumber *longitude = location.firstObject;
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
                NSDictionary *tempDic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
                CLLocationCoordinate2D carCoor = BMKCoorDictionaryDecode(tempDic);//转换后的百度坐标
                success(carCoor);
                
            }
        } failure:^(NSError *error) {
            failure();
        }];
    }
}

//计算距离
+ (NSString *)metersBetweenCoordinate2D1:(CLLocationCoordinate2D )coor1
                           Coordinate2D2:(CLLocationCoordinate2D )coor2
                              completion:(void (^)(NSString *distance,BOOL walk))completion{
    CLLocationDistance distance = [YDBiBiDataManager distanceWithCoor1:coor1 coor2:coor2];
    NSString *distanceString;
    BOOL walk = NO;
    if (distance > 1000) {
        distanceString = [NSString stringWithFormat:@"%.1fkm",distance/1000];
    }else{
        walk = YES;
        distanceString = [NSString stringWithFormat:@"%ldm",(NSInteger)distance];
    }
    if (completion) {
        completion(distanceString,walk);
    }
    return distanceString;
}

+ (CLLocationDistance)distanceWithCoor1:(CLLocationCoordinate2D)coor1
                                  coor2:(CLLocationCoordinate2D)coor2{
    BMKMapPoint point1 = BMKMapPointForCoordinate(coor1);
    BMKMapPoint point2 = BMKMapPointForCoordinate(coor2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    return distance;
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
        NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",end.latitude,end.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:urlsting]];
    }
}

@end

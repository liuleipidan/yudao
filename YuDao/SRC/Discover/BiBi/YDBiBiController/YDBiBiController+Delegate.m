//
//  YDBiBiController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/5.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiController+Delegate.h"
#import "YDBiBiController+Methods.h"
#import "YDBiBiPopViewController.h"
#import "YDRescueDetailController.h"

@implementation YDBiBiController (Delegate)

#pragma mark - LLTabBarDelegate
- (void)tabBarDidSelectedNormalButton:(NSInteger )index{
    NSLog(@"index = %ld",index);
    switch (index) {
        case 0:
        {
            if (_parkingLotAnnotations) {
                [_mapView removeAnnotations:_parkingLotAnnotations];
                _parkingLotAnnotations = nil;
            }
            [self reloadCarLocationView];
            break;}
        case 1:
        {
            
            break;}
        case 2:
        {
            
            break;}
        case 3:
        {
            [self addParkingLotAnnotation];
            break;}
        default:
            break;
    }
    
}
//点击tab加号
- (void)tabBarDidSelectedRiseButton{
//    if (!_blurView) {
//        _blurView = [[YDBlurView alloc] init];
//    }
//    UIImage *image = [_mapView takeSnapshot];
//    [_blurView setBgImage:image];
//    [_blurView showInView:self.view animated:YES];
    YDBiBiPopViewController *popVC = [[YDBiBiPopViewController alloc] initWithBackgroundImage:[UIImage fullScreenshots]];
    YDWeakSelf(self);
    [popVC setSelectedItemBlock:^(NSInteger index){
        switch (index) {
            case 0://加油站
            {
                [weakself addGasStationAnnotation];
                break;}
            case 1://4S店
            {
                
                break;}
            case 2://救助
            {
                
                break;}
                
            default:
                break;
        }
    }];
    [self presentViewController:popVC animated:NO completion:nil];
}


#pragma mark - BMKMapViewDelegate
/**
 *返回标注视图
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation.title isEqualToString:@"我的位置"]) {
        YDUserAnnotationView *userAn = [[YDUserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userAnnotation"];
        userAn.centerOffset = CGPointMake(0, -28);
        [userAn setAvatarUrl:[YDUserDefault defaultUser].user.ud_face];
        return userAn;
    }else if ([annotation.title isEqualToString:@"我的爱车"]){
        BMKAnnotationView *carAn = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"carAnnotation"];
        carAn.image = [UIImage imageNamed:@"discover_car_icon"];
        BMKActionPaopaoView *paopao = [[BMKActionPaopaoView alloc] initWithCustomView:_carppView];
        carAn.paopaoView = paopao;
        return carAn;
    }
    else if ([annotation.title isEqualToString:@"停车场"]){
        YDPointAnnotation *plAnnotation = (YDPointAnnotation *)annotation;
        BMKAnnotationView *plAn = [[BMKAnnotationView alloc] initWithAnnotation:plAnnotation reuseIdentifier:@"parkingLotAnnotation"];
        plAn.canShowCallout = NO;
        if (plAnnotation.index == 0) {
            _selectedAnView = plAn;
            plAn.image = [UIImage imageNamed:@"discover_parkingLot_selected-1"];
        }else{
            plAn.image = [UIImage imageNamed:@"discover_bibi_locationIcon"];
        }
        return plAn;
    }
    else if ([annotation.title isEqualToString:@"4s店"]){
        
    }
    else if ([annotation.title isEqualToString:@"加油站"]){
        YDPointAnnotation *plAnnotation = (YDPointAnnotation *)annotation;
        BMKAnnotationView *plAn = [[BMKAnnotationView alloc] initWithAnnotation:plAnnotation reuseIdentifier:@"gasStationAnnotation"];
        plAn.canShowCallout = NO;
        if (plAnnotation.index == 0) {
            _selectedAnView = plAn;
            plAn.image = [UIImage imageNamed:@"discover_gasstatoin_selected"];
        }else{
            plAn.image = [UIImage imageNamed:@"discover_bibi_locationIcon"];
        }
        return plAn;
    }
    return nil;
}
/**
 *当选中一个annotation views时，调用此接口
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    NSString *title = view.annotation.title;
    //CLLocationCoordinate2D pt = view.annotation.coordinate;
    
    if ([title isEqualToString:@"停车场"]) {
        YDPointAnnotation *annotation = (YDPointAnnotation *)view.annotation;
        if (_selectedAnView) {
            _selectedAnView.image = [UIImage imageNamed:@"discover_bibi_locationIcon"];
        }
        view.image = [UIImage imageNamed:@"discover_parkingLot_selected-1"];
        _selectedAnView = view;
        //偏移collectionView
        [_collectionView setContentOffset:CGPointMake((SCREEN_WIDTH-20)*annotation.index, 0) animated:YES];
        
//        NSLog(@"title = %@",title);
//        NSLog(@"name = %@,address = %@",annotation.name,annotation.address);
//        CLLocationCoordinate2D coor1 = [YDUserLocation sharedLocation].userLocation.location.coordinate;
//        CLLocationDistance distance = [YDBiBiDataManager distanceWithCoor1:coor1 coor2:pt];
//        BOOL walk = distance < 1000 ? YES : NO;
//        [self showNavigationStartCoor:coor1 endCoor:pt isWalk:walk];
    }else if ([title isEqualToString:@"加油站"]){
        //discover_gasstatoin_selected
        YDPointAnnotation *annotation = (YDPointAnnotation *)view.annotation;
        if (_selectedAnView) {
            _selectedAnView.image = [UIImage imageNamed:@"discover_bibi_locationIcon"];
        }
        view.image = [UIImage imageNamed:@"discover_gasstatoin_selected"];
        _selectedAnView = view;
        //偏移collectionView
        [_collectionView setContentOffset:CGPointMake((SCREEN_WIDTH-20)*annotation.index, 0) animated:YES];
    }
    
}

#pragma mark - YDBiBiCollectionViewDelegate
//滑动到相应的item
- (void)collectionView:(YDBiBiCollectionView *)view scrollToItem:(YDPointAnnotation *)item{
    [_mapView selectAnnotation:item animated:YES];
    [_mapView setCenterCoordinate:item.coordinate animated:YES];
}
//点击相应的item
- (void)collectionView:(YDBiBiCollectionView *)view selectedItem:(YDPointAnnotation *)item{
    YDRescueDetailController *rescueVC = [YDRescueDetailController new];
    YDRescueDetailDataManager *data = [YDRescueDetailDataManager new];
    data.name = item.name;
    data.avatarURL = @"";
    data.address = item.address;
    data.details = @"爆胎了！不会换胎求救援！";
    data.coor = item.coordinate;
    data.distance = item.distance;
    data.isWalk = item.isWalk;
    [rescueVC setData:data];
    [self.navigationController pushViewController:rescueVC animated:YES];
}

@end

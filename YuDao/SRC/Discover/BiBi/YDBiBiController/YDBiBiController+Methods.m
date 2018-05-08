//
//  YDBiBiController+Methods.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/5.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiController+Methods.h"
#import "YDCollectionCenterXItemFlowLayout.h"
#import "YDBiBiController+Delegate.h"
@implementation YDBiBiController (Methods)

/**
 重置车辆标注
 */
- (void)reloadCarLocationView{
    YDWeakSelf(self);
    [YDBiBiDataManager reloadCarLocation:@80 success:^(CLLocationCoordinate2D carCoor) {
        __block BOOL tempWalk = NO;
        NSString *distance = [YDBiBiDataManager metersBetweenCoordinate2D1:carCoor Coordinate2D2:[YDUserLocation sharedLocation].userLocation.location.coordinate completion:^(NSString *distance, BOOL walk) {
            tempWalk = walk;
        }];
        if (!weakself.carppView) {
            weakself.carppView = [[YDCarPaopaoView alloc] initWithFrame:CGRectMake(0, 0, 135, 50)];
            [weakself.carppView setSelectedGoBlock:^{
                [weakself showNavigationStartCoor:[YDUserLocation sharedLocation].userLocation.location.coordinate endCoor:weakself.carAnnotation.coordinate isWalk:tempWalk];
            }];
        }
        [weakself.carppView setDistance:distance];
        if (weakself.carAnnotation) {
            [weakself.mapView removeAnnotation:weakself.carAnnotation];
        }
        weakself.carAnnotation = [YDPointAnnotation pointAnnotationWith:carCoor title:@"我的爱车"];
        [weakself.mapView addAnnotation:weakself.carAnnotation];
        [weakself.mapView selectAnnotation:weakself.carAnnotation animated:YES];
        [weakself.mapView setCenterCoordinate:carCoor animated:YES];
    } failure:^{
        
    }];
}

/**
 添加停车场标注
 */
- (void)addParkingLotAnnotation{
    
    if (!_parkingLotAnnotations) {
        _parkingLotAnnotations = [NSMutableArray array];
    }else{
        [_mapView removeAnnotations:_parkingLotAnnotations];
        [_parkingLotAnnotations removeAllObjects];
    }
    if (_collectionView) {
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [_collectionView reloadData:nil cellType:0];
    }
    YDMapSearchManager *msm = [YDMapSearchManager new];
    YDWeakSelf(self);
    [msm startSearchWith:YDMapSearchTypeParkingLot location:[YDUserLocation sharedLocation].userLocation.location.coordinate searchCompletionBlock:^(YDMapSearchType type, NSArray<BMKPoiInfo *> *list) {
        if (list && list.count > 0) {
            [list enumerateObjectsUsingBlock:^(BMKPoiInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YDPointAnnotation *plAnnotation = [YDPointAnnotation pointAnnotationWith:obj.pt title:@"停车场"];
                plAnnotation.name = obj.name;
                plAnnotation.address = obj.address;
                plAnnotation.index = idx;
                __block BOOL iswalk = NO;
                plAnnotation.distance = [YDBiBiDataManager metersBetweenCoordinate2D1:[YDUserLocation sharedLocation].userLocation.location.coordinate Coordinate2D2:obj.pt completion:^(NSString *distance, BOOL walk) {
                    iswalk = walk;
                }];
                plAnnotation.isWalk = iswalk;
                [weakself.parkingLotAnnotations addObject:plAnnotation];
            }];
            [weakself.mapView addAnnotations:weakself.parkingLotAnnotations];
            [weakself.mapView setCenterCoordinate:[YDUserLocation sharedLocation].userLocation.location.coordinate animated:YES];
            [weakself showCollectionViewWithData:weakself.parkingLotAnnotations cellType:YDBiBiCollectionViewTypeNormal];
        }else{
            [YDMBPTool showText:@"3KM内没有停车场"];
        }
    }];
}
/**
 添加加油站标注
 */
- (void)addGasStationAnnotation{
    if (!_parkingLotAnnotations) {
        _parkingLotAnnotations = [NSMutableArray array];
    }else{
        [_mapView removeAnnotations:_parkingLotAnnotations];
        [_parkingLotAnnotations removeAllObjects];
    }
    if (_collectionView) {
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [_collectionView reloadData:nil cellType:0];
    }
    YDMapSearchManager *msm = [YDMapSearchManager new];
    YDWeakSelf(self);
    [msm startSearchWith:YDMapSearchTypeGasStation location:[YDUserLocation sharedLocation].userLocation.location.coordinate searchCompletionBlock:^(YDMapSearchType type, NSArray<BMKPoiInfo *> *list) {
        if (list && list.count > 0) {
            [list enumerateObjectsUsingBlock:^(BMKPoiInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YDPointAnnotation *plAnnotation = [YDPointAnnotation pointAnnotationWith:obj.pt title:@"加油站"];
                plAnnotation.name = obj.name;
                plAnnotation.address = obj.address;
                plAnnotation.index = idx;
                plAnnotation.distance = [YDBiBiDataManager metersBetweenCoordinate2D1:[YDUserLocation sharedLocation].userLocation.location.coordinate Coordinate2D2:obj.pt completion:nil];
                [weakself.parkingLotAnnotations addObject:plAnnotation];
            }];
            [weakself.mapView addAnnotations:weakself.parkingLotAnnotations];
            [weakself.mapView setCenterCoordinate:[YDUserLocation sharedLocation].userLocation.location.coordinate animated:YES];
            [weakself showCollectionViewWithData:weakself.parkingLotAnnotations cellType:YDBiBiCollectionViewTypeNormal];
        }else{
            [YDMBPTool showText:@"3KM内没有加油站"];
        }
        
    }];
}

/**
 初始设置地图中心点和添加用户气泡
 */
- (void)setMapCenterAndUserAnnotataion:(BMKUserLocation*)userLocation{
    NSLog(@"setMapCenterAndUserAnnotataion");
    //中心位置
    [_mapView setMapStatusWithCoordinate:userLocation.location.coordinate];
    [_mapView updateLocationData:userLocation];
    //当前用户气泡
    _userAnnotation = [YDPointAnnotation pointAnnotationWith:userLocation.location.coordinate title:@"我的位置"];
    [_mapView addAnnotation:_userAnnotation];
}

/**
 弹出选择导航的alertview
 */
- (void)showNavigationStartCoor:(CLLocationCoordinate2D)startCoor
                        endCoor:(CLLocationCoordinate2D)endCoor
                         isWalk:(BOOL )walk{
    NSArray *selects = nil;
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        selects = @[@"使用百度地图",@"使用高德地图"];
    }else{
        selects = @[@"使用百度地图"];
    }
    [UIAlertController YD_alertController:self title:@"导航" subTitle:nil items:selects style:UIAlertControllerStyleActionSheet clickBlock:^(NSInteger index) {
        if (index == 1) {
            [YDBiBiDataManager openBaiduMapNavigate:walk start:startCoor end:endCoor];
        }else{
            [YDBiBiDataManager openGaodeMapNavigateStart:startCoor end:endCoor];
        }
    }];
}
/**
 弹出collectoinView
 */
- (void)showCollectionViewWithData:(NSArray *)data cellType:(YDBiBiCollectionViewType)cellType{
    CGFloat collectionViewHeight;
    if (cellType == YDBiBiCollectionViewTypeNormal) {
        collectionViewHeight = 92;
    }else{
        collectionViewHeight = 0;
    }
    if (!_collectionView) {
        YDCollectionCenterXItemFlowLayout *layout = [[YDCollectionCenterXItemFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH-30, collectionViewHeight);
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.headerReferenceSize = CGSizeMake(15, collectionViewHeight);
        layout.footerReferenceSize = CGSizeMake(15, collectionViewHeight);
        _collectionView = [[YDBiBiCollectionView alloc] initWithFrame:CGRectMake(100, 100, 100, 100) collectionViewLayout:layout dataSource:data cellType:cellType];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bibiDelegate = self;
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-70);
            make.height.mas_equalTo(0);
        }];
    }else{
        [_collectionView reloadData:data cellType:cellType];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(collectionViewHeight);
        }];
    } completion:^(BOOL finished) {
        
    }];
    
}

@end

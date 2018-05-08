//
//  YDLocationMapController.m
//  YuDao
//
//  Created by 汪杰 on 16/11/30.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDLocationMapController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Utils/BMKOpenRouteOption.h>
#import <BaiduMapAPI_Utils/BMKOpenRoute.h>
#import <BaiduMapAPI_Utils/BMKNavigation.h>



@interface YDLocationMapController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,systemActionSheetDelegate>

@property (nonatomic,strong) BMKMapView        *mapView;//地图视图
@property (nonatomic,strong) BMKLocationService  *service;//定位服务
@property (nonatomic, strong) BMKGeoCodeSearch   *geoCodeSearch; // 百度逆地理编码

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) UIView *locationView;

@end

@implementation YDLocationMapController
{
    BMKUserLocation       *_userLocation;
    CLLocationCoordinate2D _carCoordinate2D;
    BMKPointAnnotation    *_userAnnotation;
    BMKPointAnnotation    *_carAnnotation;
    
    UILabel             *_userLoclabel;
    UILabel             *_carLoclabel;
    UILabel             *_distance;
    
    BOOL                _initFlag;
    BMKRouteSearch       *_routesearch;
    
    BOOL                _walk;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置";
    //初始化地图
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    [self.mapView setTrafficEnabled:YES];
    self.mapView.showsUserLocation = NO;
    
    _initFlag = true;//刚进入地图以用户位置为地图中心
    _walk   = false; //是否步行
    
    //初始化路线规划
    _routesearch = [[BMKRouteSearch alloc] init];
    _routesearch.delegate = self;
    
    //添加到view上
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.locationView];
    
    //初始化定位
    self.service = [[BMKLocationService alloc] init];
    [self.service startUserLocationService];
    
    //反地理位置编码
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    NSString *userLocation = [YDUserLocation sharedLocation].address;
    _userLoclabel.text = [NSString stringWithFormat:@"我的位置:%@",userLocation?userLocation:@"~"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    
    self.mapView.delegate =self;
    //设置代理
    self.service.delegate = self;
    self.geoCodeSearch.delegate = self;
    [self.service startUserLocationService];
    
    [self refreshCarLocation];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    
    self.mapView.delegate = nil;
    self.service.delegate = nil;
    self.geoCodeSearch.delegate = nil;
    _routesearch.delegate = nil;
}

#pragma mark -------BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    _userLocation = userLocation;
    if (_initFlag) {
        self.mapView.centerCoordinate = _userLocation.location.coordinate;
        _initFlag = false;
    }
    //更新位置数据
    [self.mapView updateLocationData:userLocation];

    if (_userAnnotation) {
        [self.mapView removeAnnotation:_userAnnotation];
    }
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = _userLocation.location.coordinate;
    annotation.title = @"我的位置";
    _userAnnotation = annotation;
    
    [self.mapView addAnnotation:_userAnnotation];
    
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        BMKAddressComponent *addDetail = result.addressDetail;
        NSString *address = nil;
        address = [addDetail.streetName stringByAppendingString:addDetail.streetNumber];
        _carLoclabel.text = [NSString stringWithFormat:@"车辆位置:%@",address?address:@"~"];
    }
}

#pragma mark - systemActionSheetDelegate - 弹出视图代理
- (void)systemActionSheetDidTouchedIndex:(NSInteger )index{
    if (index == 1) {
        [self openBaiduMapWalkOrCarNavigate:_walk];
    }else if (index == 2){
        //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",_carAnnotation.coordinate.latitude,_carAnnotation.coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];

        }
    }
}
#pragma mark - 开启百度导航
- (void)openBaiduMapWalkOrCarNavigate:(BOOL )walk{
    if (walk) {
        //初始化调启导航时的参数管理类
        BMKNaviPara* para = [[BMKNaviPara alloc]init];
        //初始化终点节点
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        //指定终点经纬度
        end.pt = _carAnnotation.coordinate;
        //指定终点名称
        end.name = @"爱车";
        //指定终点
        para.endPoint = end;
        
        //指定返回自定义scheme
        para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
        
    }else{
        BMKOpenDrivingRouteOption *opt = [[BMKOpenDrivingRouteOption alloc] init];
        //    opt.appName = @"SDK调起Demo";
        opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
        //初始化起点节点
        BMKPlanNode* start = [[BMKPlanNode alloc]init];
        //指定起点经纬度
        start.pt = _userAnnotation.coordinate;
        //指定起点名称
        start.name = @"我的位置";
        //start.cityName = @"普罗纳商务广场";
        //指定起点
        opt.startPoint = start;
        
        //初始化终点节点
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        end.pt = _carAnnotation.coordinate;
        //指定终点名称
        end.name = @"爱车";
        //end.cityName = @"西湖";
        opt.endPoint = end;
        
    }
    
}

#pragma mark - Events
- (void)touchNavigationAction:(UIGestureRecognizer *)tap{
    NSArray *selects = nil;
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        selects = @[@"使用百度地图",@"使用高德地图"];
    }else{
        selects = @[@"使用百度地图"];
    }
    YDSystemActionSheet *actionS = [[YDSystemActionSheet alloc] initViewWithMultiTitles:selects title:@"导航"];
    actionS.systemDelegate = self;
    [actionS show];
    [self.view addSubview:actionS];

}

//MARK:刷新车辆位置
- (void)refreshCarLocation{
    NSDictionary *parameter = @{@"access_token":YDAccess_token,
                                @"ug_id":self.currentCarId?self.currentCarId:@0};
    YDLog(@"parameter = %@",parameter);
    [YDNetworking getUrl:kCarLocationURL parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *data = [[responseObject mj_JSONObject] objectForKey:@"data"];
        NSArray *location = [data objectForKey:@"loc"];
        if (location) {
            NSNumber *latitude = location.lastObject;
            NSNumber *longitude = location.firstObject;
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);//原始坐标
            //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
            NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
            //转换GPS坐标至百度坐标(加密后的坐标)
            testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
            //解密加密后的坐标字典
            _carCoordinate2D = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
            
            if (_carAnnotation) {
                [self.mapView removeAnnotation:_carAnnotation];
            }
            //设置车辆位置 大头针
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = _carCoordinate2D;
            annotation.title = @"爱车";
            _carAnnotation = annotation;
            [_mapView addAnnotation:annotation];
            
            BMKMapPoint point1 = BMKMapPointForCoordinate(_carCoordinate2D);
            BMKMapPoint point2 = BMKMapPointForCoordinate(_userLocation.location.coordinate);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
            
            NSString *distanceString = nil;
            if (distance > 1000) {
                _walk = false;
                distanceString = [NSString stringWithFormat:@"距离:%.1fKM",distance/1000];
            }else{
                _walk = true;
                distanceString = [NSString stringWithFormat:@"距离:%ldM",(NSInteger)distance];
            }
            
            _distance.text = distanceString;
            
            //获取车辆地理位置
            BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
            reverseGeocodeSearchOption.reverseGeoPoint = _carCoordinate2D;
            [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
            [self.mapView mapForceRefresh];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        YDLog(@"error = %@",error);
    }];
}

#pragma mark - Events
- (void)selectViewAction:(UIButton *)sender{
    switch (sender.tag - 1000) {
        case 0:
        {
            [self.mapView setCenterCoordinate:_userLocation.location.coordinate];
            self.mapView.zoomLevel = 18;
            //self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
             [self.mapView selectAnnotation:_userAnnotation animated:YES];
            break;}
        case 1:
        {
            if (_carAnnotation) {
                [self.mapView setCenterCoordinate:_carAnnotation.coordinate];
                self.mapView.zoomLevel = 18;
                //self.mapView.userTrackingMode = BMKUserTrackingModeNone;
                [self.mapView selectAnnotation:_carAnnotation animated:YES];
            }else{
                [YDMBPTool showInfoImageWithMessage:@"暂未获得车辆位置请等待" hideBlock:nil];
            }
            
            break;}
        case 2:
        {
            [self refreshCarLocation];
            break;}
        default:
            break;
    }
}

#pragma mark -------BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        if (annotation.coordinate.latitude == _carAnnotation.coordinate.latitude && annotation.coordinate.longitude == _carAnnotation.coordinate.longitude) {
            BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"carAnnotation"];
            newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
            //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
            newAnnotationView.annotation=annotation;
            newAnnotationView.image = [[UIImage imageNamed:@"MapView_location_bg"] scalingToSize:CGSizeMake(kWidth(156), kHeight(174))];   //把大头针换成别的图片
            UIImageView *tempImageV = [[UIImageView alloc] init];
            
            NSString *logo = [[YDCarHelper sharedHelper] getOneCarWithCarid:self.currentCarId].ug_brand_logo;
            [tempImageV sd_setImageWithURL:YDURL(logo) placeholderImage:[UIImage imageNamed:@""]];
            [newAnnotationView addSubview:tempImageV];
            tempImageV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, 10, 15, 10));
            tempImageV.sd_cornerRadiusFromWidthRatio = @0.5;
            return newAnnotationView;
        }
        if ([annotation isEqual:_userAnnotation]) {
            BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userAnnotation"];
            newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
            //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
            newAnnotationView.annotation=annotation;
            newAnnotationView.image = [[UIImage imageNamed:@"MapView_location_bg"] scalingToSize:CGSizeMake(kWidth(156), kHeight(174))];   //把大头针换成别的图片
            
            UIImageView *tempImageV = [[UIImageView alloc] init];
            
            NSString *ud_face = [YDUserDefault defaultUser].user.ud_face;
            [tempImageV sd_setImageWithURL:YDURL(ud_face) placeholderImage:[UIImage imageNamed:kDefaultAvatarPath]];
            [newAnnotationView addSubview:tempImageV];
            tempImageV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, 10, 15, 10));
            tempImageV.sd_cornerRadiusFromWidthRatio = @0.5;

            return newAnnotationView;
        }
    }
    return nil;
}
//地图加载完成
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    UIButton *button = [self.selectView viewWithTag:1000];
    [self selectViewAction:button];
    }



- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = [UIColor whiteColor];
        _selectView.frame = CGRectMake(SCREEN_WIDTH-60,SCREEN_HEIGHT-270,40,120);
        _selectView.layer.cornerRadius = 8;
        
        UIButton *locBtn     = [YDUIKit buttonWithImage:[UIImage imageNamed:@"MapView_userLoaction"] selectedImage:[UIImage imageNamed:@"MapView_userLoaction"] selector:@selector(selectViewAction:)  target:self];
        UIButton *carBtn     = [YDUIKit buttonWithImage:[UIImage imageNamed:@"MapView_carLocation"] selectedImage:[UIImage imageNamed:@"MapView_carLocation"] selector:@selector(selectViewAction:)  target:self];
        UIButton *refreshBtn = [YDUIKit buttonWithImage:[UIImage imageNamed:@"MapView_refresh"] selectedImage:[UIImage imageNamed:@"MapView_refresh"] selector:@selector(selectViewAction:)  target:self];
        
        [@[locBtn,carBtn,refreshBtn] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = (UIButton *)obj;
            btn.tag = 1000+idx;
        }];
        
        UIView *topLine      = [UIView new];
        topLine.backgroundColor = [UIColor colorGrayLine];
        UIView *bottomLine   = [UIView new];
        bottomLine.backgroundColor = [UIColor colorGrayLine];
        [_selectView sd_addSubviews:@[locBtn,carBtn,refreshBtn,topLine,bottomLine]];
        
        locBtn.sd_layout
        .leftEqualToView(_selectView)
        .rightEqualToView(_selectView)
        .topSpaceToView(_selectView,0)
        .heightRatioToView(_selectView,0.33);
        
        topLine.sd_layout
        .leftSpaceToView(_selectView,2)
        .rightSpaceToView(_selectView,2)
        .topSpaceToView(locBtn,0)
        .heightIs(1);
        
        carBtn.sd_layout
        .centerYEqualToView(_selectView)
        .leftEqualToView(_selectView)
        .rightEqualToView(_selectView)
        .heightEqualToWidth();
        
        bottomLine.sd_layout
        .leftEqualToView(topLine)
        .rightEqualToView(topLine)
        .topSpaceToView(carBtn,0)
        .heightIs(1);
        
        refreshBtn.sd_layout
        .leftEqualToView(_selectView)
        .rightEqualToView(_selectView)
        .bottomEqualToView(_selectView)
        .heightEqualToWidth();
    }
    return _selectView;
}


- (UIView *)locationView{
    if (!_locationView) {
        _locationView = [[UIView alloc] init];
        _locationView.backgroundColor = [UIColor whiteColor];
        _locationView.frame = CGRectMake(0, SCREEN_HEIGHT-134, SCREEN_WIDTH, 70);
        
        UILabel *userLoclabel = [YDUIKit labelTextColor:[UIColor colorTextGray] fontSize:14];
        UILabel *carLoclabel = [YDUIKit labelTextColor:[UIColor colorTextGray] fontSize:14];
        [_locationView sd_addSubviews:@[userLoclabel,carLoclabel]];
        
        userLoclabel.frame = CGRectMake(10, 5, SCREEN_WIDTH*0.7, 21);
        carLoclabel.frame = CGRectMake(10, CGRectGetMaxY(userLoclabel.frame)+10, SCREEN_WIDTH*0.7, 21);
        userLoclabel.text = [NSString stringWithFormat:@"我的位置:～"];
        carLoclabel.text = [NSString stringWithFormat:@"车辆位置:～"];
        _userLoclabel = userLoclabel;
        _carLoclabel = carLoclabel;
        
        UIImageView *navigateImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MapView_navigation"]];
        
        UILabel   *distanceLabel = [YDUIKit labelTextColor:[UIColor colorTextGray] fontSize:14 textAlignment:NSTextAlignmentCenter];
        
        [@[navigateImageV,distanceLabel] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *view = (UIView *)obj;
            view.userInteractionEnabled = YES;
            [_locationView addSubview:view];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchNavigationAction:)];
            [view addGestureRecognizer:tap];
            
        }];
        
        navigateImageV.frame = CGRectMake(SCREEN_WIDTH-68, 5, 34, 34);
        distanceLabel.frame = CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(userLoclabel.frame)+15, 100, 21);
        
        _distance = distanceLabel;
        
    }
    return _locationView;
}


@end

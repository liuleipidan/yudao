//
//  YDLoveCarController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiController.h"
#import "YDBiBiController+Delegate.h"
#import "YDBiBiController+Methods.h"

@interface YDBiBiController ()


@end

@implementation YDBiBiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bbc_initUI];
    
}

- (void)bbc_initUI{
    [self.navigationItem setTitle:@"爱车"];
    
    [self.view addSubview:self.tabBar];
    [_tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(TABBAR_HEIGHT);
    }];
    _mapView = [YDMapView mapViewWithDelegate:self];
    [self.view insertSubview:_mapView belowSubview:_tabBar];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(_tabBar.mas_top).offset(0);
    }];
    
    if ([YDUserLocation sharedLocation].userLocation) {
        [self setMapCenterAndUserAnnotataion:[YDUserLocation sharedLocation].userLocation];
    }
    
    [self.view addSubview:self.selectedView];
    [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-90);
        make.height.mas_equalTo(102);
        make.width.mas_equalTo(34);
    }];
    
    //一秒后请求车辆位置及添加标注，以免未取到用户位置
    [self performSelector:@selector(reloadCarLocationView) withObject:nil afterDelay:1];
    
    //右边item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dicover_bibi_rightItem_list"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[_mapView viewWillAppear];
    YDWeakSelf(self);
    [[YDUserLocation sharedLocation] setUpdateLocationBlock:^(BMKUserLocation *userLocation){
        if ([YDUserLocation sharedLocation].userLocation == nil) {
            [weakself setMapCenterAndUserAnnotataion:userLocation];
        }
        [weakself.mapView updateLocationData:userLocation];
        weakself.userAnnotation.coordinate = userLocation.location.coordinate;
    }];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    
}

//
- (void)rightItemAction:(UIBarButtonItem *)item{
    
}

#pragma mark  - Getters
- (LLTabBar *)tabBar{
    if (!_tabBar) {
        _tabBar = [[LLTabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-TABBAR_HEIGHT-NAVBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT)];
        _tabBar.tabBarItemAttributes = @[@{kLLTabBarItemAttributeTitle : @"我的爱车", kLLTabBarItemAttributeNormalImageName : @"discover_lovecar_normal", kLLTabBarItemAttributeSelectedImageName : @"discover_lovecar_selected", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                        @{kLLTabBarItemAttributeTitle : @"救援", kLLTabBarItemAttributeNormalImageName : @"discover_rescue_normal", kLLTabBarItemAttributeSelectedImageName : @"discover_rescue_selected", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                        @{kLLTabBarItemAttributeTitle : @"  ", kLLTabBarItemAttributeNormalImageName : @"discover_add_icon", kLLTabBarItemAttributeSelectedImageName : @"discover_add_icon", kLLTabBarItemAttributeType : @(LLTabBarItemRise)},
                                        @{kLLTabBarItemAttributeTitle : @"打招呼", kLLTabBarItemAttributeNormalImageName : @"discover_sayhi_normal", kLLTabBarItemAttributeSelectedImageName : @"discover_sayhi_selected", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                        @{kLLTabBarItemAttributeTitle : @"停车场", kLLTabBarItemAttributeNormalImageName : @"discover_parkinglot_normal", kLLTabBarItemAttributeSelectedImageName : @"discover_parkinglot_selected", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)}];
        _tabBar.delegate = self;
    }
    return _tabBar;
}

- (YDLCSelectView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[YDLCSelectView alloc] init];
        YDWeakSelf(self);
        [_selectedView setSelectedBlock:^(NSInteger index){
            switch (index) {
                case 0:
                {
                    if ([YDUserLocation sharedLocation].userLocation) {
                        [weakself.mapView setCenterCoordinate:[YDUserLocation sharedLocation].userLocation.location.coordinate];
                    }else{
                    
                    }
                    break;}
                case 1:
                {
                    if (weakself.carAnnotation) {
                        [weakself.mapView setCenterCoordinate:weakself.carAnnotation.coordinate];
                        [weakself.mapView selectAnnotation:weakself.carAnnotation animated:YES];
                    }else{
                        [weakself reloadCarLocationView];
                    }
                    break;}
                case 2:
                {
                    [weakself reloadCarLocationView];
                    break;}
                    
                default:
                    break;
            }
        }];
    }
    return _selectedView;
}

@end

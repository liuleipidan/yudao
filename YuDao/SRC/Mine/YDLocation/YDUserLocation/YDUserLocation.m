//
//  YDUserLocation.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUserLocation.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface YDUserLocation()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) BMKGeoCodeSearch   *geoCodeSearch; // 百度逆地理编码

@property (nonatomic, strong) BMKReverseGeoCodeResult *geoResult;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSTimer          *uploadTimer; //上传位置

@end

static YDUserLocation *userLocation = nil;
static dispatch_once_t onceToken;
@implementation YDUserLocation

+ (YDUserLocation *)sharedLocation{
    dispatch_once(&onceToken, ^{
        userLocation = [[YDUserLocation alloc] init];
    });
    return userLocation;
}

+ (void)attemptDealloc{
    onceToken = 0;
    if (userLocation.uploadTimer) {
        [userLocation.uploadTimer invalidate];
        userLocation.uploadTimer = nil;
    }
    userLocation = nil;
}

- (instancetype)init{
    if (self = [super init]) {
//*************  初始化定位服务  *******************
        _locService = [[BMKLocationService alloc]init];
        //定位的最小更新距离
        _locService.distanceFilter = 100.f;
        //定位精度
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
        //最小更新角度
        _locService.headingFilter = kCLHeadingFilterNone;
        //是否会被系统自动暂停。默认为YES
        _locService.pausesLocationUpdatesAutomatically = NO;
        //是否允许后台定位更新。默认为NO
        //_locService.allowsBackgroundLocationUpdates = YES;
        //开始定位
        [self startLocation];
        
//*************  第一次定位时间  *******************
        _date = [NSDate date];
        
//*************  初始定时器上传位置  *******************
        //开启上传用户信息
        _uploadTimer = [NSTimer scheduledTimerWithTimeInterval:180.f target:self selector:@selector(uploadUserLocation) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc{
    YDLog(@"dealloc class = %@",NSStringFromClass([self class]));
}

#pragma mark - Public Methods
- (void)startLocation{
    _locService.delegate = self;
    [_locService startUserLocationService];
}
- (void)stopLocation{
    _locService.delegate = nil;
    [_locService startUserLocationService];
}

#pragma mark  - Private Methods
#pragma mark - 上传用户位置
- (void)uploadUserLocation{
    NSString *ud_location = [NSString stringWithFormat:@"%f,%f",self.userCoor.longitude,self.userCoor.latitude];
    NSString *city = self.userCity;
    if (YDHadLogin && ud_location && city && city.length > 1) {
        NSString *subCity = [city substringWithRange:NSMakeRange(0, city.length-1)];
        NSDictionary *paramters = @{@"access_token":YDAccess_token,
                                    @"ud_location":ud_location?ud_location:@"",
                                    @"ud_city":subCity?subCity:@""};
        
        [YDNetworking postUrl:kUploadUserLocationUrl parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            YDLog(@"上传用户位置失败,error = %@",error);
            
        }];
    }
    
}

/** 逆地理编码 */
- (void)reverseLocation:(BMKUserLocation *)userLocation{
    if (userLocation) {
        if (_geoCodeSearch == nil) {
            //*************  初始地理位置编码  *******************
            _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
            _geoCodeSearch.delegate = self;
        }
        CLLocationCoordinate2D pt;
        pt.longitude = userLocation.location.coordinate.longitude;
        pt.latitude = userLocation.location.coordinate.latitude;
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        if (![_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption]) {
            YDLog(@"发起当前用户妮地理编码失败");
        }
    }
}

#pragma mark - Getters
- (CLLocationCoordinate2D )userCoor{
    return self.userLocation.location.coordinate;
}
- (NSString *)userCity{
    return self.geoResult.addressDetail.city;
}
- (NSString *)userdistrict{
    return self.geoResult.addressDetail.district;
}
- (NSString *)address{
    return self.geoResult.address;
}
- (NSString *)businessCircle{
    return self.geoResult.businessCircle;
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (_updateLocationBlock) {
        _updateLocationBlock(userLocation);
    }
    _userLocation = userLocation;
    //逆地理编码结果为nil或时间离上次检索已经相差5分钟
    if (!_geoResult || [NSDate differFirstDate:[NSDate date] secondDate:_date differType:YDDifferDateTypeMinute] >= 5) {
        _date = [NSDate date];
        [self reverseLocation:userLocation];
    }
}

/**
 *定位失败
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    YDLog(@"定位失败 error = %@",error);
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_OPEN_NO_ERROR) {
        _geoResult = result;
        _geoCodeSearch.delegate = nil;
        _geoCodeSearch = nil;
    }
}

@end

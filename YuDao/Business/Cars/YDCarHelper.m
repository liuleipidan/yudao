//
//  YDCarHelper.m
//  YuDao
//
//  Created by 汪杰 on 16/11/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDCarHelper.h"

static YDCarHelper *carHelper;
static dispatch_once_t ch_once;

@interface YDCarHelper()

@property (nonatomic, strong) YDDBCarStore *carStore;


@end

@implementation YDCarHelper

+ (YDCarHelper *)sharedHelper{
    dispatch_once(&ch_once, ^{
        carHelper = [[YDCarHelper alloc] init];
    });
    return carHelper;
}

- (id)init{
    if (self = [super init]) {
        
        _carStore = [YDDBCarStore new];
        
        _carArray = [self limitCarsCount];
        
        _delegate = (GCDMulticastDelegate <YDCarHelperDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    return self;
}

+ (void)attemptDealloc{
    if (carHelper.carArray) {
        [carHelper.carArray removeAllObjects];
        carHelper.carArray = nil;
    }
    /*
    ch_once = 0;
    carHelper = nil;
     */
}

- (void)downloadCarsData:(NSString *)access_token{
    [YDNetworking GET:kCarsListURL parameters:@{@"access_token":access_token} success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200]) {
            [self insertCars:[YDCarDetailModel mj_objectArrayWithKeyValuesArray:data]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)filterUnboundDeviceCars:(void (^)(BOOL allCarHadBind,NSArray *cars,BOOL canAdd))completion{
    BOOL canAdd = YES;
    if (self.carArray.count == kShowCarsCount) {
        canAdd = NO;
    }
    __block NSMutableArray *cars = [NSMutableArray array];
    [self.carArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YDCarDetailModel *car = obj;
        if (car.boundDeviceType != YDCarBoundDeviceTypeBOX_AIR) {
            [cars addObject:car];
        }
    }];
    BOOL allCarHadBind = NO;
    if (canAdd == NO && cars.count == 0) {
        allCarHadBind = YES;
    }
    if (completion) {
        completion(allCarHadBind,cars,canAdd);
    }
}

- (void)setDefaultCar:(YDCarDetailModel *)defaultCar{
    //如果新的默认车辆id不等于当前默认车辆id
    if ([defaultCar.ug_status isEqual:@1]) {
        [self insertOneCar:defaultCar];
    }
    //修改其他车辆的默认状态
    NSMutableArray *tempCars = [self.carArray mutableCopy];
    for (YDCarDetailModel *car in tempCars) {
        if (![car.ug_id isEqual:defaultCar.ug_id]) {
            car.ug_status = @0;
            [self insertOneCar:car];
        }
    }
    
    [self.delegate carHelperDefaultCarHadChanged:defaultCar];
}

- (YDCarDetailModel *)defaultCar{
    return [self defaultOrBindObdCar];
}

- (void)insertOneCar:(YDCarDetailModel *)car{
    
    YDCarDetailModel *oldCar = [self.carStore getOneCarWithCarid:car.ug_id];
    if (oldCar &&
        oldCar.boundDeviceType != car.boundDeviceType) {
        [self.delegate carHelperCarBoundTypeDidChanged:car];
    }
    
    if (![self.carStore insertOrUpdateCar:car]) {
        YDLog(@"插入单辆车失败");
    }
    
    self.carArray = [self limitCarsCount];
}

- (void)insertCars:(NSArray<YDCarDetailModel *> *)cars{
    [self deleteAllCars];
    
    [cars enumerateObjectsUsingBlock:^(YDCarDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.carStore insertOrUpdateCar:obj]) {
            YDLog(@"插入多辆车失败");
        }
    }];
    
    self.carArray = [self limitCarsCount];
    [self.delegate carHelperLoginRequestGarageComplation];
}

- (NSMutableArray *)allCars{
    return [self.carStore getAllCars];
}

- (NSMutableArray *)limitCarsCount{
    NSMutableArray<YDCarDetailModel *> *allCars = [_carStore getAllCars];
    if (allCars.count == 0 || allCars.count == kShowCarsCount) {
        return allCars;
    }
    
    __block NSMutableArray *tempCars = [NSMutableArray array];
    //优先加入默认车辆
    [tempCars addObject:self.defaultCar];
    
    [allCars enumerateObjectsUsingBlock:^(YDCarDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.ug_id isEqual:self.defaultCar.ug_id] &&
            obj.boundDeviceType != YDCarBoundDeviceTypeNone) {
            [tempCars addObject:obj];
        }
        if (tempCars.count == kShowCarsCount) {
            *stop = YES;
        }
    }];
    
    if (tempCars.count < kShowCarsCount) {
        [allCars enumerateObjectsUsingBlock:^(YDCarDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj.ug_id isEqual:self.defaultCar.ug_id]) {
                [tempCars addObject:obj];
                *stop = YES;
            }
        }];
    }
    
    return tempCars;
}

- (NSArray *)hadBoundDeviceCars{
    NSMutableArray<YDCarDetailModel *> *allCars = [_carStore getAllCars];
    if (allCars.count == 0) {
        return allCars;
    }
    
    __block NSMutableArray *tempCars = [NSMutableArray array];
    [allCars enumerateObjectsUsingBlock:^(YDCarDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.boundDeviceType != YDCarBoundDeviceTypeNone) {
            [tempCars addObject:obj];
        }
    }];
    
    return [tempCars subarrayWithRange:NSMakeRange(0, tempCars.count > kShowCarsCount ? kShowCarsCount : tempCars.count)];
}

- (void)syncServerCarInformation:(NSNumber *)ug_id
                         success:(void (^)(YDCarDetailModel *newCar))success
                         failure:(void (^)(void))failure{
    if (ug_id == nil) {
        return;
    }
    NSDictionary *parameters = @{@"access_token":YDAccess_token,
                                 @"ug_id":ug_id};
    [YDNetworking GET:kCarDetailDataURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            YDCarDetailModel *car = [YDCarDetailModel mj_objectWithKeyValues:data];
            [self insertOneCar:car];
            if (success) {
                success(car);
            }
        }else{
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

- (YDCarDetailModel *)getOneCarWithCarid:(NSNumber *)carid{
    return [self.carStore getOneCarWithCarid:carid];
}

//获取默认车辆，无默认车辆取已经绑定obd车辆
- (YDCarDetailModel *)defaultOrBindObdCar{
    NSMutableArray *cars = [self.carStore getAllCars];
    if (cars.count == 0) {
        return nil;
    }
    else if (cars.count == 1){
        return cars.firstObject;
    }
    YDCarDetailModel *defaultCar = [self.carStore getDefaultCarByUserId:YDUser_id];
    if (defaultCar == nil) {
        defaultCar = [self.carStore getBoundOBDCarByUserId:YDUser_id];
    }
    if (defaultCar == nil) {
        defaultCar = cars.firstObject;
    }
    
    return defaultCar;
    
    #pragma mark - BUG:出现所有车辆都为非默认车辆，上传服务器修改此车辆为默认车辆,并同步本地数据库
//    if (model.ug_status == nil || [model.ug_status isEqual:@0]) {
//        YDLog(@"BUG：出现所有车辆都是未绑定车辆");
//        model.ug_status = @1;
//        NSMutableDictionary *paramer = model.mj_keyValues;
//        [paramer setObject:YDAccess_token forKey:@"access_token"];
//        //表示认证状态
//        NSInteger auth = model.ug_vehicle_auth.integerValue;
//        if (auth == 1 || auth == 2) {
//            [paramer setObject:@1 forKey:@"up"];
//        }
//        if(auth == 0 || auth == 3){
//            [paramer setObject:@0 forKey:@"up"];
//        }
//        [YDNetworking POST:kChangeCarDataURL parameters:paramer success:^(NSNumber *code, NSString *status, id data) {
//            if ([code isEqual:@200]) {
//                //修改数据库信息
//                [[YDCarHelper sharedHelper] insertOneCar:model];
//                [[YDCarHelper sharedHelper] setDefaultCar:model];
//            }
//        } failure:^(NSError *error) {
//            YDLog(@"BUG：出现所有车辆都是未绑定车辆,修改失败");
//        }];
//    }
}

- (void)deleteAllCars{
    if ([_carStore deleteAllCars]) {
        YDLog(@"删除所有车辆成功");
        [_carArray removeAllObjects];
        self.defaultCar = nil;
    }else{
        YDLog(@"删除所有车辆失败");
    }
}

//删除一辆车
- (void)deleteOneCar:(YDCarDetailModel *)car{
    if ([self.carStore deleteOneCar:car.ug_id]) {
        YDLog(@"数据库删除一辆车成功");
        self.carArray = [self limitCarsCount];
        //删除完车辆,需重置默认车辆
        if ([car.ug_status isEqual:@1] && self.carArray.count > 0) {
            __block NSInteger carIdx = 0;
            [self.carArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YDCarDetailModel *car = obj;
                if ([car.ug_boundtype isEqual:@1]) {
                    carIdx = idx;
                    *stop = YES;
                }else{
                    carIdx = 0;
                }
            }];
            YDCarDetailModel *defaultCar = [self.carArray objectAtIndex:carIdx];
            defaultCar.ug_status = @1;
            NSMutableDictionary *para = defaultCar.mj_keyValues;
            [para setObject:YDAccess_token forKey:@"access_token"];
            NSNumber *up = nil;
            NSInteger auth = defaultCar.ug_vehicle_auth.integerValue;
            if (auth == 1 || auth == 2) {
                up = @1;
            }else if(auth == 0 || auth == 3){
                up = @0;
            }
            [para setObject:up forKey:@"up"];
            [YDNetworking postUrl:kChangeCarDataURL parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *response = [responseObject mj_JSONObject];
                NSNumber *status_code = [response valueForKey:@"status_code"];
                if ([status_code isEqual:@200]) {
                    [self setDefaultCar:defaultCar];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                YDLog(@"删除车辆后设置默认车辆失败 error = %@",error);
            }];
        }
    }else{
        YDLog(@"数据库删除一辆车失败");
    }
    
}

/**
 *  修改车辆的绑定OBD状态
 */
- (void)updateCarOBDStatus:(NSInteger )boundStatus
                       uid:(NSNumber *)uid
                     ug_id:(NSNumber *)ug_id{
    if ([self.carStore updateCarOBDStatus:boundStatus uid:uid ug_id:ug_id]) {
        self.carArray = [self limitCarsCount];
    }
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [self.delegate addDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [self.delegate removeDelegate:delegate delegateQueue:delegateQueue];
}

@end

//
//  YDDBCarStore.m
//  YuDao
//
//  Created by 汪杰 on 16/11/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBCarStore.h"
#import "YDDBCarSQL.h"
#import "YDDBManager.h"
#import "NSObject+Category.h"

@implementation YDDBCarStore

- (id)init
{
    if (self = [super init]) {
        self.dbQueue = [YDDBManager sharedInstance].commonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            YDLog(@"DB: 车库表创建失败");
        }
        //1.03增加字段channelid->渠道id
        [self addColumWithTableName:CAR_TABLE_NAME columName:@"channelid" columType:@"INTEGER" defaultValue:@"0"];

        //1.0.91加入空静绑定状态
        [self addColumWithTableName:CAR_TABLE_NAME columName:@"ug_bind_air" columType:@"INTEGER" defaultValue:@"0"];
        
        //1.0.91加入空静扩展属性
        [self addColumWithTableName:CAR_TABLE_NAME columName:@"airInfo" columType:@"TEXT" defaultValue:@""];
    }
    return self;
}

- (BOOL)createTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_CAR_TABLE, CAR_TABLE_NAME];
    return [self createTable:CAR_TABLE_NAME withSQL:sqlString];
}

- (BOOL)insertOrUpdateCar:(YDCarDetailModel *)car{
    //YDCarDetailModel * tempClass = [car checkAndChangeObjectPropertyValue];
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_CAR,CAR_TABLE_NAME];
    NSArray *arrayPara = [NSArray arrayWithObjects:
                          YDNoNilNumber(car.ug_status),
                          YDNoNilNumber(car.ug_boundtype),
                          YDNoNilString(car.ug_plate_title),
                          YDNoNilNumber(car.ug_city),
                          YDNoNilString(car.ug_brand_logo),
                          YDNoNilNumber(car.ug_province),
                          YDNoNilString(car.ug_city_name),
                          YDNoNilString(car.ug_brand_name),
                          YDNoNilNumber(car.vb_id),
                          YDNoNilNumber(car.vm_id),
                          YDNoNilNumber(car.ug_vehicle_auth),
                          YDNoNilString(car.ug_series_name),
                          YDNoNilString(car.ug_plate),
                          YDNoNilString(car.ug_province_name),
                          YDNoNilString(car.ug_engine),
                          YDNoNilString(car.wz_date),
                          YDNoNilNumber(car.ug_annual_inspection),
                          YDNoNilNumber(car.ug_maintenance),
                          YDNoNilNumber(car.ug_id),
                          car.ub_id.integerValue == 0 ? [YDUserDefault defaultUser].user.ub_id : car.ub_id,
                          YDNoNilNumber(car.vs_id),
                          YDNoNilString(car.ug_model_name),
                          YDNoNilString(car.ug_frame_number),
                          YDNoNilString(car.ug_positive),
                          YDNoNilString(car.ug_negative),
                          YDNoNilString(car.bo_imei),
                          YDNoNilNumber(car.channelid),
                          YDNoNilNumber(car.ug_bind_air),
                          car.airInfo ? [car.airInfo mj_JSONString] : @"",
                          nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrayPara];
    return ok;
}
- (NSMutableArray *)getAllCars{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CARS, CAR_TABLE_NAME,[YDUserDefault defaultUser].user.ub_id.integerValue];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            YDCarDetailModel *car = [self y_createCarBy:retSet];
            [data addObject:car];
        }
        [retSet close];
    }];
    return data;
}

- (YDCarDetailModel *)getOneCarWithCarid:(NSNumber *)carid{
    __block YDCarDetailModel *car = [YDCarDetailModel new];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CAR,CAR_TABLE_NAME,carid? [carid integerValue]:0,[YDUserDefault defaultUser].user.ub_id.integerValue];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *reSet) {
        while ([reSet next]) {
            car = [self y_createCarBy:reSet];
        }
        [reSet close];
    }];
    return car;
}

- (YDCarDetailModel *)getDefaultCarByUserId:(NSNumber *)userId{
    __block YDCarDetailModel *defaultCar = nil;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_DEFAULT_CAR,CAR_TABLE_NAME,userId];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            defaultCar = [self y_createCarBy:rsSet];
        }
        [rsSet close];
    }];
    return defaultCar;
}

- (YDCarDetailModel *)getBoundOBDCarByUserId:(NSNumber *)userId{
    __block YDCarDetailModel *boundOBDCar = nil;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_BOUNDOBD_CAR,CAR_TABLE_NAME,userId];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *rsSet) {
        while ([rsSet next]) {
            boundOBDCar = [self y_createCarBy:rsSet];
        }
        [rsSet close];
    }];
    return boundOBDCar;
}

- (YDCarDetailModel *)y_createCarBy:(FMResultSet *)reSet{
    YDCarDetailModel * car = [[YDCarDetailModel alloc] init];
    car.ug_status = [NSNumber numberWithInt:[reSet intForColumn:@"ug_status"]];
    car.ug_boundtype = [NSNumber numberWithInt:[reSet intForColumn:@"ug_boundtype"]];
    car.ug_plate_title = [reSet stringForColumn:@"ug_plate_title"];
    car.ug_city = @([reSet intForColumn:@"ug_city"]);
    car.ug_brand_logo = [reSet stringForColumn:@"ug_brand_logo"];
    car.ug_province = @([reSet intForColumn:@"ug_province"]);
    car.ug_city_name = [reSet stringForColumn:@"ug_city_name"];
    car.ug_brand_name = [reSet stringForColumn:@"ug_brand_name"];
    car.vb_id = [NSNumber numberWithInt:[reSet intForColumn:@"vb_id"]];
    car.vm_id = [NSNumber numberWithInt:[reSet intForColumn:@"vm_id"]];
    car.ug_vehicle_auth = [NSNumber numberWithInt:[reSet intForColumn:@"ug_vehicle_auth"]];
    car.ug_series_name = [reSet stringForColumn:@"ug_series_name"];
    car.ug_plate = [reSet stringForColumn:@"ug_plate"];
    car.ug_province_name = [reSet stringForColumn:@"ug_province_name"];
    car.ug_engine = [reSet stringForColumn:@"ug_engine"];
    car.wz_date = [reSet stringForColumn:@"wz_date"];
    car.ug_annual_inspection = [NSNumber numberWithInt:[reSet intForColumn:@"ug_annual_inspection"]];
    car.ug_maintenance = [NSNumber numberWithInt:[reSet intForColumn:@"ug_maintenance"]];
    car.ug_id = [NSNumber numberWithInt:[reSet intForColumn:@"ug_id"]];
    car.ub_id = [NSNumber numberWithInt:[reSet intForColumn:@"ub_id"]];
    car.vs_id = [NSNumber numberWithInt:[reSet intForColumn:@"vs_id"]];
    car.ug_model_name = [reSet stringForColumn:@"ug_model_name"];
    car.ug_frame_number = [reSet stringForColumn:@"ug_frame_number"];
    car.ug_positive = [reSet stringForColumn:@"ug_positive"];
    car.ug_negative = [reSet stringForColumn:@"ug_negative"];
    car.bo_imei = [reSet stringForColumn:@"bo_imei"];
    car.channelid = [NSNumber numberWithInt:[reSet intForColumn:@"channelid"]];
    car.ug_bind_air = [NSNumber numberWithInt:[reSet intForColumn:@"ug_bind_air"]];
    car.airInfo = [[[reSet stringForColumn:@"airInfo"] mj_JSONObject] mutableCopy];
    
    return car;
}

- (BOOL)deleteAllCars{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_CARS,CAR_TABLE_NAME];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

/**
 *  删除一辆车
 *
 *  @return YES 删除成功  NO 删除失败
 */
- (BOOL)deleteOneCar:(NSNumber *)ug_id{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_CAR,CAR_TABLE_NAME,ug_id,[YDUserDefault defaultUser].user.ub_id];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

/**
 *  修改车辆的绑定OBD状态
 */
- (BOOL)updateCarOBDStatus:(NSInteger )boundStatus
                       uid:(NSNumber *)uid
                     ug_id:(NSNumber *)ug_id{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_CAR_OBD_STATUS,CAR_TABLE_NAME,boundStatus,uid,ug_id];
    BOOL ok = [self excuteSQL:sqlString];
    if (ok) {
        YDLog(@"修改车辆OBD状态成功");
    }else{
        YDLog(@"修改车辆OBD状态失败");
    }
    return ok;
}

@end

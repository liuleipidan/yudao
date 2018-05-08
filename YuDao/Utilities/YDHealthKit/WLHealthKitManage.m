                //
//  WLHealthKitManage.m
//  GymJT
//
//  Created by 王亮 on 16/11/7.
//  Copyright © 2016年 张炫赫. All rights reserved.
//

#import "WLHealthKitManage.h"
#import "HKHealthStore+WLPLExtensions.h"

@implementation WLHealthKitManage

+(id)manager{
    return [[self alloc] init];
}

- (id)init{
    if (self = [super init]) {
        [self getPermissions];
    }
    return self;
}

/*!
 *  @author Lcong, 15-04-20 17:04:44
 *
 *  @brief  检查是否支持获取健康数据
 */
- (void)getPermissions
{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return;
    }
    if ([HKHealthStore isHealthDataAvailable]) {
        //组装需要读写的数据类型
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesRead];
        
        //注册需要读写的数据类型，也可以在“健康”APP中重新修改
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"%@\n\n%@",error, [error userInfo]);
                return ;
            }
        }];
    }
}

/*!
 *  @author Lcong, 15-04-20 16:04:42
 *
 *  @brief  写权限
 *
 *  @return 集合
 */
- (NSSet *)dataTypesToWrite
{
    return [NSSet set];
}

/*!
 *  @author Lcong, 15-04-20 16:04:03
 *
 *  @brief  读权限
 *
 *  @return 集合
 */
- (NSSet *)dataTypesRead
{
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    return [NSSet setWithObjects:stepCountType, nil];
}

/*!
 *  @author Lcong, 15-04-20 17:04:02
 *
 *  @brief  实时获取当天步数
 */
- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler
{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return;
    }
    HKSampleType *sampleType =
    [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKObserverQuery *query =
    [[HKObserverQuery alloc]
     initWithSampleType:sampleType
     predicate:nil
     updateHandler:^(HKObserverQuery *query,
                     HKObserverQueryCompletionHandler completionHandler,
                     NSError *error) {
         if (error) {
             // Perform Proper Error Handling Here...
             NSLog(@"*** An error occured while setting up the stepCount observer. %@ ***",
                   error.localizedDescription);
             //                 handler(0,error);
             //                 abort();
         }
         [self getSeparateStepCount:[WLHealthKitManage predicateForSamplesToday] completionHandler:^(double value, NSError *error) {
             handler(value,error);
         }];
     }];
    [self.healthStore executeQuery:query];
}

/*!
 *  @author Lcong, 15-04-20 17:04:03
 *
 *  @brief  获取步数
 *
 *  @param predicate 时间段
 */
- (void)getSeparateStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler
{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return;
    }
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    [self.healthStore aapl_zonghe_mostRecentQuantitySampleOfType:stepType predicate:predicate completion:^(double num, NSError *error) {
        if(error)
        {
            handler(0,error);
        }
        else
        {
            handler(num,error);
        }
    }];
}


- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(NSArray *value, NSError *error))handler{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return;
    }
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:stepType predicate:predicate completion:^(NSArray *results, NSError *error) {
        if(error || !results.count){
            handler(0,error);
        }
        else{
            double num = 0.0;
            
            NSMutableArray *steps = [NSMutableArray array];
            
            NSDate *beginTime;
            beginTime = [results[0] startDate];
            
            int i=0;
            for(HKQuantitySample *quantitySample in results)
            {
                if ([quantitySample.startDate day] == [beginTime day]) {
                    HKQuantity *quantity = quantitySample.quantity;
                    HKUnit *heightUnit = [HKUnit countUnit];
                    double usersHeight = [quantity doubleValueForUnit:heightUnit];
                    num += usersHeight;
                }
                else{
                    
                    [steps addObject:@{@"steps":@(num),
                                       @"time":beginTime}];
                    num = 0;
                    
                    HKQuantity *quantity = quantitySample.quantity;
                    HKUnit *heightUnit = [HKUnit countUnit];
                    double usersHeight = [quantity doubleValueForUnit:heightUnit];
                    num += usersHeight;
                    beginTime = quantitySample.startDate;
                }
                i++;
                
                if (results.count == i) {
                    [steps addObject:@{@"steps":@(num),
                                       @"time":beginTime}];
                }
            }
            steps = (NSMutableArray *)[[steps reverseObjectEnumerator] allObjects];
            handler(steps,error);
        }
    }];
}

/*!
 *  @author Lcong, 15-04-20 17:04:38
 *
 *  @brief  获取卡路里
 */
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler
{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return;
    }
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        
        double value = [sum doubleValueForUnit:[HKUnit kilocalorieUnit]];
        NSLog(@"%@卡路里 ---> %.2lf",quantityType.identifier,value);
        if(handler)
        {
            handler(value,error);
        }
    }];
    [self.healthStore executeQuery:query];
}

#pragma mark - Getter
- (HKHealthStore *)healthStore{
    if (_healthStore == nil) {
        self.healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

/*!
 *  @author Lcong, 15-04-20 17:04:10
 *
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

/**
 获取自定时间段
 
 @param fromData 开始时间
 @param toDate   结束时间
 
 @return 时间段
 */
+ (NSPredicate *)predicateForFrom:(NSDate *)fromData To:(NSDate *)toDate {
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:fromData endDate:toDate options:HKQueryOptionNone];
    return predicate;
}

@end

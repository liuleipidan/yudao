//
//  YDSingleRankingViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSingleRankingViewModel.h"

@interface YDSingleRankingViewModel()

/**
 类型字符串，用于请求数据的参数
 */
@property (nonatomic, copy  ) NSString *typeString;

@end

@implementation YDSingleRankingViewModel

- (id)initWithDataType:(YDRankingListDataType )dataType{
    if (self = [super init]) {
        _dataType = dataType;
        _condition = -1;
    }
    return self;
}

- (void)requestRankingListByFilterCondition:(YDRankingListFilterCondition)condition completion:(void (^)(YDRequestReturnDataType))completion{
    _condition = condition;
    NSMutableDictionary *para = [@{@"access_token":YDAccess_token,
                                   @"rankingtype":self.typeString} mutableCopy];
    
    [para setObject:[YDSingleRankingViewModel filterConditionString:condition] forKey:@"type"];
    //若为附近，则需加上经纬度参数
    if (condition == YDRankingListFilterConditionNearby) {
        NSString *lon = [NSString stringWithFormat:@"%f",[YDUserLocation sharedLocation].userCoor.longitude];
        NSString *lat = [NSString stringWithFormat:@"%f",[YDUserLocation sharedLocation].userCoor.latitude];
        NSString *location = [lon stringByAppendingString:[NSString stringWithFormat:@",%@",lat]];
        [para setObject:location forKey:@"ud_location"];
    }
    YDWeakSelf(self);
    [YDNetworking GET:kAllRankinglistURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            NSMutableArray<YDRankingListModel *> *allData = [YDRankingListModel mj_objectArrayWithKeyValuesArray:data];
            weakself.currentUserData = nil;
            [allData enumerateObjectsUsingBlock:^(YDRankingListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.type = weakself.dataType;
                [obj setRankingText:[NSString stringWithFormat:@"%ld",idx+1]];
                if (obj.ranking) {
                    weakself.currentUserData = obj;
                    [weakself.currentUserData setRankingText:[NSString stringWithFormat:@"%@",obj.ranking]];
                    if (obj.ranking.integerValue <= 10) {
                        weakself.isTopTen = YES;
                    }
                    else{
                        //移除其中的当前用户数据
                        [allData removeObjectAtIndex:idx];
                        weakself.isTopTen = NO;
                    }
                }
            }];
            //只取其中十条数据
            weakself.data = [NSMutableArray arrayWithArray:[allData subarrayWithRange:NSMakeRange(0, allData.count > 10 ? 10 : allData.count)]];
            completion(allData.count > 0 ? YDRequestReturnDataTypeSuccess : YDRequestReturnDataTypeNULL);
        }
        else{
            if (weakself.data.count > 0) {
                [weakself.data removeAllObjects];
            }
            completion(YDRequestReturnDataTypeFailure);
        }
    } failure:^(NSError *error) {
        if (weakself.data.count > 0) {
            [weakself.data removeAllObjects];
        }
        
        if (error.code == -1001) {
            completion(YDRequestReturnDataTypeTimeout);
        }
        else{
            completion(YDRequestReturnDataTypeFailure);
        }
    }];
}

/**
 通过筛选枚举获得字符串
 */
+ (NSString *)filterConditionString:(YDRankingListFilterCondition )condition{
    static NSDictionary *rankingListCondition;
    if (rankingListCondition == nil) {
        rankingListCondition = @{
                                 @(YDRankingListFilterConditionNo):@"",
                                 @(YDRankingListFilterConditionNearby):@"nearby",
                                 @(YDRankingListFilterConditionFriend):@"friend",
                                 @(YDRankingListFilterConditionBoy):@"sexb",
                                 @(YDRankingListFilterConditionGirl):@"sexg",
                                 @(YDRankingListFilterConditionCar):@"line",
                                 };
    }
    return rankingListCondition[@(condition)] ? : @"";
}

/**
 通过数据类型获取请求参数
 */
+ (NSString *)rankingListDataTypeString:(YDRankingListDataType )dataType{
    static NSDictionary *rankingListDataType;
    if (rankingListDataType == nil) {
        rankingListDataType = @{
                                @(YDRankingListDataTypeSpeed):@"speed",
                                @(YDRankingListDataTypeMileage):@"mileage",
                                @(YDRankingListDataTypeOilwear):@"oilwear",
                                @(YDRankingListDataTypeStop):@"stranded",
                                @(YDRankingListDataTypeScore):@"credit",
                                @(YDRankingListDataTypeLike):@"enjoy",
                                };
    }
    return rankingListDataType[@(dataType)] ? : @"";
}

#pragma mark - Getters
- (NSString *)typeString{
    return [YDSingleRankingViewModel rankingListDataTypeString:self.dataType];
}

@end

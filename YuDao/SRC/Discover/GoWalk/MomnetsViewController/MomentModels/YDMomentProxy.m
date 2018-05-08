//
//  YDMomentProxy.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentProxy.h"

@interface YDMomentProxy()

@property (nonatomic,assign) NSUInteger pageIndex;

@property (nonatomic,assign) NSUInteger pageSize;

@end

@implementation YDMomentProxy

- (instancetype)init{
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 10;
    }
    return self;
}

- (void)requestMomentsByControllerType:(YDGowalkViewControllerType )type
                            completion:(void (^)(YDRequestReturnDataType))completion{
    _pageIndex = 1;
    self.noMore = NO;
    [YDNetworking GET:kGowalkURL parameters:[self parameterWithType:type] success:^(NSNumber *code, NSString *status, id data) {
        NSArray *tempArr = [YDMoment mj_objectArrayWithKeyValuesArray:data];
        if (tempArr.count > 0) {
            _moments = [NSMutableArray arrayWithArray:tempArr];
            if (tempArr.count < _pageSize) {
                self.noMore = YES;
                completion(YDRequestReturnDataTypeNomore);
            }
            else{
                completion(YDRequestReturnDataTypeSuccess);
            }
            
        }else{
            completion(YDRequestReturnDataTypeNULL);
        }
    } failure:^(NSError *error) {
        if (error.code == -1001) {
            completion(YDRequestReturnDataTypeTimeout);
        }else{
            completion(YDRequestReturnDataTypeFailure);
        }
    }];
}

- (void)requestMoreMomentsByControllerType:(YDGowalkViewControllerType )type
                            completion:(void (^)(YDRequestReturnDataType))completion{
    if (_moments == nil) {
        _moments = [NSMutableArray array];
    }
    _pageIndex ++;
    NSLog(@"type = %ld",type);
    NSLog(@"go walk param = %@",[self parameterWithType:type]);
    [YDNetworking GET:kGowalkURL parameters:[self parameterWithType:type] success:^(NSNumber *code, NSString *status, id data) {
        NSArray *tempArr = [YDMoment mj_objectArrayWithKeyValuesArray:data];
        [_moments addObjectsFromArray:tempArr];
        if (tempArr.count < 10) {
            self.noMore = YES;
            completion(YDRequestReturnDataTypeNomore);
        }
        else{
            completion(YDRequestReturnDataTypeSuccess);
        }
    } failure:^(NSError *error) {
        if (error.code == -1001) {
            completion(YDRequestReturnDataTypeTimeout);
        }else{
            completion(YDRequestReturnDataTypeFailure);
        }
    }];
}

/**
 根据动态类型获得请求数据的参数

 @param type 动态类型
 @return 参数
 */
- (NSMutableDictionary *)parameterWithType:(YDGowalkViewControllerType )type{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"access_token":YDAccess_token,
                                                                                     @"pageindex":@(self.pageIndex),
                                                                                     @"pagesize":@(self.pageSize)
                                                                                     }];
    static NSDictionary *typeDic = nil;
    if (typeDic == nil) {
        typeDic = @{
                    @(YDGowalkViewControllerTypeNewest):@"newest",
                    @(YDGowalkViewControllerTypeNearby):@"nearby",
                    @(YDGowalkViewControllerTypeFriend):@"friend"
                    };
    }
    [parameter setObject:typeDic[@(type)] ? : @"newest" forKey:@"type"];
    if (type == YDGowalkViewControllerTypeNearby) {
        NSString *location = [NSString stringWithFormat:@"%f,%f",[YDUserLocation sharedLocation].userCoor.longitude,[YDUserLocation sharedLocation].userCoor.latitude];
        [parameter setObject:location forKey:@"ud_location"];
    }
    
    return parameter;
}

@end

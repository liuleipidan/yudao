//
//  YDCardPackageHelper.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCardPackageProxy.h"

@interface YDCardPackageProxy()

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation YDCardPackageProxy

- (id)init{
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 10;
    }
    return self;
}

- (void)requestCardPackageCompletion:(void (^)(YDRequestReturnDataType))completion{
    _pageIndex = 1;
    
    NSDictionary *parameters = @{
                                 @"access_token":YDAccess_token,
                                 @"pageindex":@(self.pageIndex),
                                 @"pagesize":@(self.pageSize)
                                 };
    
    [YDNetworking GET:kCardPackageURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        NSArray *tempArr = [YDCard mj_objectArrayWithKeyValuesArray:data];
        if (tempArr.count > 0) {
            self.data = [NSMutableArray arrayWithArray:tempArr];
            completion(YDRequestReturnDataTypeSuccess);
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

- (void)requestMoreCardseCompletion:(void (^)(YDRequestReturnDataType))completion{
    _pageIndex ++;
    NSDictionary *parameters = @{
                                 @"access_token":YDAccess_token,
                                 @"pageindex":@(self.pageIndex),
                                 @"pagesize":@(self.pageSize)
                                 };
    [YDNetworking GET:kCardPackageURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        NSArray *tempArr = [YDCard mj_objectArrayWithKeyValuesArray:data];
        [self.data addObjectsFromArray:tempArr];
        completion(tempArr.count < 10 ? YDRequestReturnDataTypeNomore : YDRequestReturnDataTypeSuccess);
    } failure:^(NSError *error) {
        if (error.code == -1001) {
            completion(YDRequestReturnDataTypeTimeout);
        }else{
            completion(YDRequestReturnDataTypeFailure);
        }
    }];
}

+ (void)requestCardDetailsByCouponId:(NSNumber *)couponId
                             success:(void (^)(YDCard *card))success
                             failure:(void (^)(void))failure{
    if (couponId == nil) {
        return;
    }
    NSDictionary *parameters = @{
                                 @"access_token":YDAccess_token,
                                 @"coupon_id":couponId
                                 };
    [YDNetworking GET:kCardDetailsURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            success([YDCard mj_objectWithKeyValues:data]);
        }else{
            failure();
        }
    } failure:^(NSError *error) {
        failure();
    }];
}

@end

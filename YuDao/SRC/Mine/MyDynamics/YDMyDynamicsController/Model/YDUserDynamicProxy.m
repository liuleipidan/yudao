//
//  YDUserDynamicProxy.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUserDynamicProxy.h"

@interface YDUserDynamicProxy()

@end

@implementation YDUserDynamicProxy

- (instancetype)init{
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 10;
        _userId = YDUser_id;
        _dynamics = [NSMutableArray array];
    }
    return self;
}

- (void)requestDynamicsCompletion:(void (^)(YDRequestReturnDataType dataType))completion{
    if (completion == nil) {
        return;
    }
    
    [YDNetworking GET:kOtherDynamicURL parameters:[self parameters] success:^(NSNumber *code, NSString *status, id data) {
        NSString *nickName = [data valueForKey:@"ub_nickname"];
        NSString *avatarURL = [data valueForKey:@"ud_face"];
        NSMutableArray *tempArr = [YDMoment mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];
        for (YDMoment *moment in tempArr) {
            moment.ub_nickname = nickName;
            moment.ud_face = avatarURL;
            moment.friend = @2;
        }
        
        //第一次
        if (self.pageIndex == 1) {
            [_dynamics removeAllObjects];
            [_dynamics addObjectsFromArray:tempArr];
            if (tempArr.count == 0) {
                completion(YDRequestReturnDataTypeNULL);
            }
            else if (tempArr.count == self.pageSize){
                [_dynamics removeLastObject];
                completion(YDRequestReturnDataTypeSuccess);
            }
            else if (tempArr.count > 0 && tempArr.count < self.pageSize){
                completion(YDRequestReturnDataTypeNomore);
            }
            else{
                YDLog(@"BUG:数据量大于pageSize");
            }
        }
        else{
            [_dynamics addObjectsFromArray:tempArr];
            if (tempArr.count < self.pageSize) {
                completion(YDRequestReturnDataTypeNomore);
            }
            else if (tempArr.count == self.pageSize){
                [_dynamics removeLastObject];
                completion(YDRequestReturnDataTypeSuccess);
            }
            else{
                YDLog(@"BUG:数据量大于pageSize");
            }
        }
        
    } failure:^(NSError *error) {
        if (error.code == -1001) {
            completion(YDRequestReturnDataTypeTimeout);
            
        }
        else{
            completion(YDRequestReturnDataTypeFailure);
        }
    }];
}

- (NSDictionary *)parameters{
    return @{
             @"access_token":YDAccess_token,
             @"ub_id":_userId,
             @"pageindex":@(_pageIndex),
             @"pagesize":@(_pageSize)
             };
}

@end

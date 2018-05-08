//
//  YDUserFilesViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUserFilesViewModel.h"

@implementation YDUserFilesViewModel

- (instancetype)initWithUserId:(NSNumber *)uid{
    if(self = [super init]){
        _uid = uid;
        _dynamics = [NSMutableArray array];
        _pageSize = 10;
    }
    return self;
}

- (void)requestUserInformation:(void (^)(void))success
                       failure:(void (^)(void))failure{
    YDWeakSelf(self);
    [YDNetworking GET:kOtherFilesURL parameters:@{@"access_token":YDAccess_token,@"ub_id":YDNoNilNumber(_uid)} success:^(NSNumber *code, NSString *status, id data) {
        if (data) {
            //YDLog(@"用户档案 data = %@",data);
            weakself.userInfo = [YDUserInfoModel mj_objectWithKeyValues:data];
            success();
        }else{
            failure();
        }
    } failure:^(NSError *error) {
        failure();
    }];
}

- (void)requestUserDynamics:(void (^)(BOOL hasMore))success
                    failure:(void (^)(void))failure{
    _pageIndex++;
    YDWeakSelf(self);
    NSDictionary *paraDic = @{@"access_token":YDAccess_token,
                              @"ub_id":YDNoNilNumber(_uid),
                              @"pageindex":@(_pageIndex),
                              @"pagesize":@(_pageSize + 1)};
    [YDNetworking GET:kOtherDynamicURL parameters:paraDic success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            NSString *nickName = [data valueForKey:@"ub_nickname"];
            NSString *avatarURL = [data valueForKey:@"ud_face"];
            
            NSMutableArray *tempArray = [YDMoment mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];
            for (YDMoment *moment in tempArray) {
                moment.ub_nickname = nickName;
                moment.ud_face = avatarURL;
                moment.friend = @2;
            }
            if (tempArray.count > 0) {
                [weakself.dynamics addObjectsFromArray:tempArray];
                BOOL hasMore = NO;
                if (tempArray.count >= (_pageSize +1) ) {
                    hasMore = YES;
                    [tempArray removeLastObject];
                }
                tempArray.count == weakself.pageSize ? success(hasMore) : success(hasMore);
            }
            else{
                success(NO);
            }
        }
        else{
            failure();
        }
    } failure:^(NSError *error) {
        failure();
    }];
}

@end

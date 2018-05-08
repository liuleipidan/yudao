//
//  YDActivityViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDActivityViewModel.h"

@implementation YDActivityViewModel

- (instancetype)init{
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 10;
    }
    return self;
}

- (void)requestActivityListWithSuccess:(void (^)(NSArray<YDActivity *> *data,BOOL hasMore))success
                               failure:(void (^)(NSNumber *code,NSString *status))failure{
    if (!_activityList) {
        _activityList = [NSMutableArray array];
    }
    YDWeakSelf(self);
    NSDictionary *para = @{@"access_token":YDAccess_token,
                           @"pageindex":@(_pageIndex),
                           @"pagesize":@(_pageSize+1)};
    
    [YDNetworking GET:kActivityListURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            NSMutableArray<YDActivity *> *messages = [YDActivity mj_objectArrayWithKeyValuesArray:data];
            BOOL hasMore = NO;
            if (messages.count == weakself.pageSize+1) {
                hasMore = YES;
                [messages removeLastObject];
            }
            if (weakself.pageIndex == 1 && weakself.activityList.count > 0) {
                [weakself.activityList removeAllObjects];
            }
            
            [weakself.activityList addObjectsFromArray:messages];
            
            success(weakself.activityList,hasMore);
        }else{
            failure(code,status);
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestActivityDetailsWithActivityId:(NSNumber *)aid
                                     success:(void (^)(YDActivityDetails *activityDetails))success
                                     failure:(void (^)(NSNumber *code,NSString *status))failure{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"aid":YDNoNilNumber(aid)}];
    if (YDHadLogin) {
        [para setObject:[YDUserDefault defaultUser].user.access_token forKey:@"access_token"];
    }
    [YDNetworking GET:kActivityDetailsURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            YDActivityDetails *activityDetails = [YDActivityDetails mj_objectWithKeyValues:data];
            success(activityDetails);
        }else{
            failure(code,status);
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestJoinActivityWithPara:(id )para
                            success:(void (^)(void))success
                            failure:(void (^)(NSNumber *code,NSString *status))failure{
    if (!para) { return;}
    [YDNetworking GET:kActivityJoinURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            success();
        }else{
            failure(code,status);
        }
    } failure:^(NSError *error) {
        failure(@0,@"报名失败");
    }];
}

@end

@implementation YDActivity

- (NSString *)joinString{
    if ([self.type isEqual:@4]) {
        return [NSString stringWithFormat:@"%@人已%@",YDNoNilNumber(self.preheat_num),@"点赞"];
    }
    return [NSString stringWithFormat:@"%@人已%@",YDNoNilNumber(self.j_num),@"报名"];
}

@end

@implementation YDActivityDetails



@end

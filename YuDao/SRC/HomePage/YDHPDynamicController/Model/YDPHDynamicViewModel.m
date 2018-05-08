//
//  YDPHDynamicViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPHDynamicViewModel.h"
#import "YDDBHPDynamicStore.h"

@implementation YDPHDynamicViewModel

- (instancetype)init{
    if (self = [super init]) {
        //优先读取数据库
        _dynamics = [YDDBHPDynamicStore selectAllHPDynamicData];
    }
    return self;
}

- (void)requsetHomePageDynamicsCompletion:(void (^)(NSArray *dynamics))completion{
    YDWeakSelf(self);
    NSDictionary *para = @{@"access_token":YDAccess_token};
    [YDNetworking GET:kDynamicURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200]) {
            NSArray *dynamics = [YDDynamicModel mj_objectArrayWithKeyValuesArray:data];
            [YDDBHPDynamicStore insertHPDynamicData:dynamics];
            weakself.dynamics = dynamics;
            completion(dynamics);
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end

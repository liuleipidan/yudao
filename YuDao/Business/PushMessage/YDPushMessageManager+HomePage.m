//
//  YDPushMessageManager+homePage.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPushMessageManager+HomePage.h"

@implementation YDPushMessageManager (HomePage)

- (void)post_requestHomePageMessagesByCurrentUserToken:(NSString *)token{
    YDWeakSelf(self);
    NSDictionary *para = @{@"access_token":YDAccess_token};
    [YDNetworking POST:kHomePageMessageURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            __block NSMutableArray *messages = [NSMutableArray array];
            NSArray  *system = [data objectForKey:@"system"];
            if (system && system.count > 0) {
                NSArray *tempSystem = [YDPushMessage mj_objectArrayWithKeyValuesArray:system];
                [messages addObjectsFromArray:tempSystem];
            }
            
            //营销活动
            NSArray *marketing = [data objectForKey:@"marketing"];
            if (marketing && marketing.count > 0) {
                [marketing enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    YDPushMessage *message = [YDPushMessage mj_objectWithKeyValues:dic];
                    [messages addObject:message];
                }];
            }
            
            [weakself.delegate receivedHomePageMessages:messages];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestPOSTPushMessagesByCurrentUserToken:(NSString *)token{
    
}

@end

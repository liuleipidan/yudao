//
//  YDHPIgonreModel.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPIgnoreModel.h"

@implementation YDHPIgnoreModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{ @"rid":@"hm_id",
             @"uid":@"ub_id",
             @"ptype":@"hm_ptype",
             @"subtype":@"hm_ctype",
             @"ignore_type":@"hm_neglect",
             @"time":@"hm_time"};
}

+ (YDHPIgnoreModel *)createIgnoreModelByModuleType:(YDHomePageModuleType)moduleType
                                           subType:(YDServerMessageType)subType{
    if (moduleType == YDHomePageModuleTypeUnknown) {
        return nil;
    }
    YDHPIgnoreModel *model = [[YDHPIgnoreModel alloc] init];
    model.rid = @0;
    model.uid = YDUser_id;
    model.ptype = @(moduleType);
    model.ignore_type = @0;
    if (moduleType != YDHomePageModuleTypeMessages) {
        model.subtype = @0;
    }
    else{
        model.subtype = @(subType);
//        switch (type) {
//            case YDServerMessageTypeWeather:
//            {
//                
//                break;}
//            case YDServerMessageTypeWeeklyReport:
//            {
//    
//                break;}
//            case YDServerMessageTypeMarketingActivity:
//            {
//    
//                break;}
//            case YDServerMessageTypeCouponSend:
//            {
//    
//                break;}
//            case YDServerMessageTypeServerPush:
//            {
//    
//                break;}
//                
//            default:
//                break;
//        }
    }
    
    return model;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"rid = %@,uid = %@,ptype = %@,subtype = %@,ignore_type = %@,time = %@",self.rid,self.uid,self.ptype,self.subtype,self.ignore_type,self.time];
}

@end

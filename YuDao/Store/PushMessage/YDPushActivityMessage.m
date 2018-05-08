//
//  YDPushActivityMessage.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPushActivityMessage.h"

@implementation YDPushActivityMessage

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"msgid":@"m_id",
             @"msgType":@"m_type",
             @"msgSubtype":@"m_subtype",
             @"senderid":@"m_ub_id",
             @"receiverid":@"m_f_ub_id",
             @"content":@"content",
             @"time":@"time",
             @"name":@"ub_nickname",
             @"avatar":@"ud_face"};
}


@end

@implementation YDPushActivityMessageDetails



@end

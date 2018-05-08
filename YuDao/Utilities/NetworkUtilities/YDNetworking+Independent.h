//
//  YDNetworking+Independent.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDNetworking.h"

/**
 相对独立的请求
 */
@interface YDNetworking (Independent)


/**
 请求OBD邀请码

 @param parameters 参数，需要包括OBD序列号和验证码
 @param completion 回调
 */
+ (NSURLSessionDataTask *)requestOBDInvitationCodeWithParamters:(id const)parameters
                                   complation:(void (^)(NSString *invitationCode))completion;

+ (NSURLSessionDataTask *)requestSenderChatMessageNotificationReceiverId:(NSString *)receiverId
                                                               messageId:(NSString *)messageId
                                                                 success:(void (^)(void))success
                                                                 failure:(void (^)(void))failure;

@end

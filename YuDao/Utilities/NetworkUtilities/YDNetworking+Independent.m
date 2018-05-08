//
//  YDNetworking+Independent.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDNetworking+Independent.h"

#define kChatMessageContentLength 40

@implementation YDNetworking (Independent)

+ (NSURLSessionDataTask *)requestOBDInvitationCodeWithParamters:(id const)parameters
                                   complation:(void (^)(NSString *invitationCode))completion{
    
    return [YDNetworking GET:kOBDIvitationCode parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        NSString *invitationCode = [data valueForKey:@"activation_code"];
        if (completion) {
            completion(invitationCode);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil);
        }
    }];
}

+ (NSURLSessionDataTask *)requestSenderChatMessageNotificationReceiverId:(NSString *)receiverId
                                                               messageId:(NSString *)messageId
                                                                 success:(void (^)(void))success
                                                                 failure:(void (^)(void))failure{
    YDChatMessage *message = [[YDChatHelper sharedInstance] getOneMessageByMsgId:messageId uid:YDUser_id fid:receiverId];
    if (message == nil) {
        return nil;
    }
    NSString *jsonstring = @"发来一条新消息";
    if (message.conversationContent.length > kChatMessageContentLength) {
        jsonstring = [message.conversationContent substringWithRange:NSMakeRange(0, kChatMessageContentLength)];
        [jsonstring stringByAppendingString:@"..."];
    }
    else if (message.conversationContent.length > 0 && message.conversationContent.length <= kChatMessageContentLength){
        jsonstring = message.conversationContent;
    }
    NSString *contentJsonString = [@{@"message":jsonstring} mj_JSONString];
    NSDictionary *parameters = @{
                                @"access_token":YDAccess_token,
                                @"f_uid":YDNoNilString(receiverId),
                                @"f_nickname":YDNoNilString([YDUserDefault defaultUser].user.ub_nickname),
                                @"content":contentJsonString,
                                 };
    return [YDNetworking GET:kSendChatNofiticationURL parameters:parameters success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"code = %@",code);
    } failure:^(NSError *error) {
        
    }];
}


@end

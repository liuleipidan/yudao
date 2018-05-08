//
//  YDChatPartner.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatPartner.h"

@implementation YDChatPartner

+ (YDChatPartner *)createChatPartnerWith:(NSNumber *)userId
                                username:(NSString *)username
                               avatarURL:(NSString *)avatarURL
                                    type:(YDChatPartnerType)type{
    YDChatPartner *partner = [[YDChatPartner alloc] init];
    partner.chat_userId = userId;
    partner.chat_username = username;
    partner.chat_avatarURL = avatarURL;
    partner.chat_partnerType = type;
    
    return partner;
}

#pragma mark - Getter
- (XMPPJID *)jid{
    return [XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",YDNoNilNumber(self.chat_userId)] domain:kHostName resource:nil];
}

@end

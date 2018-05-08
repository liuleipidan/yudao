//
//  YDChatPartner.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPJID.h"

typedef NS_ENUM(NSInteger, YDChatPartnerType) {
    YDChatPartnerTypeUser = 0,
    YDChatPartnerTypeGroup,
};

#define YDCreateChatPartner(UserId,Username,AvatarURL,Type) [YDChatPartner createChatPartnerWith:UserId username:Username avatarURL:AvatarURL type:Type]

/**
 聊天对象
 */
@interface YDChatPartner : NSObject

@property (nonatomic,strong) NSNumber *chat_userId;

@property (nonatomic,copy  ) NSString *chat_username;

@property (nonatomic,copy  ) NSString *chat_avatarURL;

@property (nonatomic,copy  ) NSString *chat_avatarPath;

@property (nonatomic,assign) YDChatPartnerType chat_partnerType;

/**
 xmpp聊天对象，只读，由chat_userId生成
 */
@property (nonatomic,strong,readonly) XMPPJID *jid;

+ (YDChatPartner *)createChatPartnerWith:(NSNumber *)userId
                                username:(NSString *)username
                               avatarURL:(NSString *)avatarURL
                                    type:(YDChatPartnerType)type;

@end

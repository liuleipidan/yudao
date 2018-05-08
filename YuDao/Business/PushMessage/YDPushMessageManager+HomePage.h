//
//  YDPushMessageManager+homePage.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPushMessageManager.h"

@interface YDPushMessageManager (HomePage)

/**
 请求首页消息

 @param token 当前用户token
 */
- (void)post_requestHomePageMessagesByCurrentUserToken:(NSString *)token;

@end

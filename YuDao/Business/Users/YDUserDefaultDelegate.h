//
//  YDUserDefaultDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/5.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDUser;
@protocol YDUserDefaultDelegate <NSObject>

@optional

/**
 用户登录成功

 @param user 当前用户
 */
- (void)defaultUserAlreadyLogged:(YDUser *)user;

/**
 用户退出
 */
- (void)defaultUserExitingLogin;

/**
 用户取消登录
 */
- (void)defaultUserCancelLogin;

/**
 用户设置信息加载完毕
 */
- (void)defaultUserSettingLoaded;

/**
 用户信息改变
 */
- (void)defaultUserInformationHadChanged;



@end

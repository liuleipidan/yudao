//
//  YDUserDefault.h
//  YuDao
//
//  Created by 汪杰 on 16/12/6.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDUser.h"
#import "YDUserDefaultDelegate.h"
#import "GCDMulticastDelegate.h"
#import "YDHPIgnoreStore.h"

/********** 用户信息快速获取 ***********/
//用户token
#define YDAccess_token [YDUserDefault defaultUser].user.access_token ? : @""
//用户id
#define YDUser_id      [YDUserDefault defaultUser].user.ub_id
//用户是否登录
#define YDHadLogin     [YDUserDefault defaultUser].user.access_token ? YES : NO

@interface YDUserDefault : NSObject

+ (YDUserDefault *)defaultUser;

@property (nonatomic, strong, getter=getUser, setter=setUser:) YDUser  *user;

/**
 暂存user信息，在进入《我的资料》赋值，在《我的资料》dealloc时置空
 */
@property (nonatomic, strong) YDUser *tempUser;

//多播代理
@property (nonatomic, strong) GCDMulticastDelegate<YDUserDefaultDelegate> *delegate;

/**
 是否需要回到首页，默认为yes，只有从服务子页面才不需要
 */
@property (nonatomic, assign) BOOL needGoBackToHomePage;

/**
 保存用户信息，主要用于登录、注册和绑定手机号（由第三方登录过来）

 @param data 用户信息字典
 */
- (void)saveUserInfo:(id )data;

/**
 退出登录，移除当前用户
 */
- (void)removeUser;

/**
 上传用户信息
 */
- (void)uploadUser:(YDUser *)user
           success:(void (^)(void))success
           failure:(void (^)(void))failure;

/**
 刷新当前用户信息，以服务器信息为准
 */
- (void)refreshUserInformationSuccess:(void (^)(void))success
                              failure:(void (^)(void))failure;

/**
 请求用户的设置信息
 */
- (void)requestUserHomePageIgnore;

/**
 请求喜欢当前用户的人数
 */
+ (void)requestLikeMyselfNumber:(void (^)(NSNumber *num))success;

/**
 添加代理
 */
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 移除代理
 */
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

@end

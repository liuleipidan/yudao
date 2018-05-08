//
//  YDUserDefault.m
//  YuDao
//
//  Created by 汪杰 on 16/12/6.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUserDefault.h"
#import "JPUSHService.h"
#import "NSString+RegularExpressionConfig.h"

#define kCurrentUserKey @"currentUser"

//上传用户信息
#define kUpUserInfoURL [kOriginalURL stringByAppendingString:@"upuserinfo"]

static YDUserDefault *userDefault = nil;

@implementation YDUserDefault

+ (YDUserDefault *)defaultUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefault = [[YDUserDefault alloc] init];
    });
    return userDefault;
}

- (id)init{
    if (self = [super init]) {
        _delegate = (GCDMulticastDelegate <YDUserDefaultDelegate> *)[[GCDMulticastDelegate alloc] init];
        self.needGoBackToHomePage = YES;
    }
    return self;
}

#pragma mark - 登录
- (void)saveUserInfo:(id )data{
    //保持用户信息及修改widget登录状态
    self.user = [YDUser mj_objectWithKeyValues:data];
    
    //登录openfire
    [[YDXMPPHelper sharedInstance] loginXmppWithUserId:[YDUserDefault defaultUser].user.ub_id password:[YDUserDefault defaultUser].user.ub_password];
    
    //上传用户registerID（极光推送对应id）
    NSString *jPushID = [YDStandardUserDefaults valueForKey:kRegistrationID] ? [YDStandardUserDefaults valueForKey:kRegistrationID] :[JPUSHService registrationID];
    if (jPushID) {
        NSDictionary *bindJPDic = @{ @"access_token":YDAccess_token,
                                     @"source":@2,
                                     @"registration_id":jPushID};
        [YDNetworking uploadJpushRegisterID:bindJPDic];
    }
    
    //请求推送消息（系统消息和好友消息）
    [[YDPushMessageManager sharePushMessageManager] requestPushMessagesByCurrentUserid:[YDUserDefault defaultUser].user.ub_id];
    
    //请求所以系统消息
    [[YDSystemMessageHelper sharedInstance] requestSystemMessagesCompletion:nil];
    
    //请求车库数据
    [[YDCarHelper sharedHelper] downloadCarsData:YDAccess_token];
    
    //请求好友数据
    [[YDFriendHelper sharedFriendHelper] downloadFriendsData:nil];
    
    //向代理发送消息
    [_delegate defaultUserAlreadyLogged:self.user];
    
    //请求首页忽略的设置信息
    [self requestUserHomePageIgnore];
    
    //动态消息数量
    [[YDMineHelper sharedInstance] requestDynamicMessagesCount];
}

#pragma mark - 退出登录，移除当前用户
- (void)removeUser{
    
    //清除所有角标
    [[YDRootViewController sharedRootViewController] clearApplicationIconAndTabBarItemsBadge];
    
    //回到首页
    [(YDNavigationController *)[YDRootViewController sharedRootViewController].selectedViewController popViewControllerAnimated:NO];
    [[YDRootViewController sharedRootViewController] setSelectedIndex:0];
    [(YDNavigationController *)[YDRootViewController sharedRootViewController].selectedViewController popViewControllerAnimated:NO];
    
    //清除好友内存
    [YDFriendHelper attemptDealloc];
    
    //清除车辆内存
    [YDCarHelper attemptDealloc];
    
    //退出openfire
    [[YDXMPPHelper sharedInstance] logoutXmpp];
    
    //移除当前用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kCurrentUserKey];
    
    //同步groupUserDefaults的登录信息
    NSUserDefaults *share = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ve-link.YuDaoApp"];
    [share setBool:NO forKey:@"kHadLogin"];
    
    //动态消息数量清零
    [[YDMineHelper sharedInstance] setDyMsgUnreadCount:0];
    
    [_delegate defaultUserExitingLogin];
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [_delegate addDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [_delegate removeDelegate:delegate delegateQueue:delegateQueue];
}

- (void)uploadUser:(YDUser *)user
           success:(void (^)(void))success
           failure:(void (^)(void))failure{
    
    if (!user.ub_nickname || user.ub_nickname.length == 0 || [user.ub_nickname re_validateEmptyString]) {
        [YDMBPTool showInfoImageWithMessage:@"昵称不可为空" hideBlock:nil];
        return;
    }
    //去掉昵称所有空格
    user.ub_nickname = [user.ub_nickname yd_trimAllWhitespace];
    NSDictionary *param = user.mj_keyValues;
    [YDNetworking POST:kUpUserInfoURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            [self setUser:user];
            success();
        }
        else{
            failure();
        }
        YDLog(@"上传用户信息 code = %@, status = %@",code,status);
    } failure:^(NSError *error) {
        YDLog(@"上传用户信息失败 error = %@",error);
        failure();
    }];
}

- (void)refreshUserInformationSuccess:(void (^)(void))success
                              failure:(void (^)(void))failure;{
    NSDictionary *para = @{@"access_token":YDNoNilString(self.user.access_token)};
    [YDNetworking GET:kUserInfoURL parameters:para success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:data];
            [tempDic setObject:self.user.access_token forKey:@"access_token"];
            YDUser *user = [YDUser mj_objectWithKeyValues:tempDic];
            self.user = user;
            if (success) {
                success();
            }
        }else{
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)requestUserHomePageIgnore{
    if (!YDHadLogin) {
        return;
    }
    [YDNetworking GET:kUserHPIgnoreListURL parameters:@{@"access_token":YDAccess_token} success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200] && data) {
            NSArray *tempArr = [YDHPIgnoreModel mj_objectArrayWithKeyValuesArray:data];
            YDHPIgnoreStore *store = [YDHPIgnoreStore manager];
            [store addHPIgnoreArray:tempArr userId:self.user.ub_id];
            YDLog(@"用户设置信息获取完毕");
            [self.delegate defaultUserSettingLoaded];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestLikeMyselfNumber:(void (^)(NSNumber *num))success{
    [YDNetworking GET:kLikeMePersonsURL parameters:@{@"access_token":YDAccess_token} success:^(NSNumber *code, NSString *status, id data) {
        NSNumber *likeNum = [data valueForKey:@"num"];
        [[YDUserDefault defaultUser].user setLikeNum:YDNoNilNumber(likeNum)];
        success(YDNoNilNumber(likeNum)); 
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Getter
- (YDUser *)getUser{
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
    return [YDUser mj_objectWithKeyValues:userDic];
}

#pragma mark - Setter
- (void)setUser:(YDUser *)user{
    
    [[NSUserDefaults standardUserDefaults] setObject:user.mj_keyValues forKey:kCurrentUserKey];
    //同步groupUserDefaults的登录信息
    NSUserDefaults *share = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ve-link.YuDaoApp"];
    [share setBool:YES forKey:@"kHadLogin"];
}

@end

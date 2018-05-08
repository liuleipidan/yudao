//
//  YDActivityWebController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDActivityWebController.h"
#import "YDActivityViewModel.h"
#import "YDActivityJoinSccessController.h"
#import "YDIntegralController.h"

@interface YDActivityWebController ()


@end

@implementation YDActivityWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"遇道"];
    
    [self.webView setAllowsBackForwardNavigationGestures:NO];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"dynamic_button_share_white" target:self action:@selector(aw_rightBarButtonItemAction:)];
    
    YDUser *userInfo = [YDUserDefault defaultUser].user;
    NSString *urlStr = [NSString stringWithFormat:kActivityDetailsHtmlURL,kHtmlEnvironmentalKey,self.activity.aid,YDAccess_token,YDNoNilString(userInfo.ub_nickname),YDNoNilString(userInfo.ub_cellphone),YDNoNilNumber(userInfo.ud_sex),[YDShortcutMethod appVersion]];
    
    NSLog(@"urlStr = %@",urlStr);
    
    [self setUrlString:urlStr];
    
    [self registerAMethodToJS:kRegisterMethodName_dataTransfer];
    
    [self registerAMethodToJS:kRegisterMethodName_login];
    
    [self registerAMethodToJS:kRegisterMethodName_pageJump];
    
    //分享成功通知
    [YDNotificationCenter addObserver:self selector:@selector(aw_activitySharedSuccessfulNotification:) name:kActivitySharedSuccessfulNotification object:nil];
    
    //开启登录回调
    [[YDUserDefault defaultUser] addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc{
    [[YDUserDefault defaultUser] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - Events
- (void)aw_activitySharedSuccessfulNotification:(NSNotification *)noti{
    [YDNetworking GET:kActicitySharedURL parameters:@{@"aid":YDNoNilNumber(self.activity.aid)} success:^(NSNumber *code, NSString *status, id data) {
        NSLog(@"分享活动成功 code = %@",code);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Public Methods
- (void)setNeedGetActivityDetails:(BOOL)needGetActivityDetails{
    _needGetActivityDetails = needGetActivityDetails;
    if (needGetActivityDetails) {
        [YDActivityViewModel requestActivityDetailsWithActivityId:self.activity.aid success:^(YDActivityDetails *activityDetails) {
            self.activity.title = activityDetails.title;
            self.activity.img_url = activityDetails.img_url;
        } failure:^(NSNumber *code, NSString *status) {
            
        }];
        _needGetActivityDetails = NO;
    }
}

#pragma mark - YDUserDefaultDelegate
- (void)defaultUserAlreadyLogged:(YDUser *)user{
    YDUser *userInfo = [YDUserDefault defaultUser].user;
    NSString *urlStr = [NSString stringWithFormat:kActivityDetailsHtmlURL,kHtmlEnvironmentalKey,self.activity.aid,YDAccess_token,YDNoNilString(userInfo.ub_nickname),YDNoNilString(userInfo.ub_cellphone),YDNoNilNumber(userInfo.ud_sex),[YDShortcutMethod appVersion]];
    NSLog(@"urlStr = %@",urlStr);
    [self setUrlString:urlStr];
}

#pragma mark - Private Methods
//分享
- (void)aw_rightBarButtonItemAction:(id)sender{
    NSDictionary *param = @{
                            @"webCode":@"AH_DATA_3"
                            };
    
    NSString *methodStr = [NSString stringWithFormat:kCallHtmlMethodPrefix,[param mj_JSONString]];
    //通过调用JS的方法获取分享需要的内容
    [self callJSMethod:methodStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSDictionary *param = [obj mj_JSONObject];
        
        NSString *status = [param objectForKey:@"status"];
        if ([status isEqualToString:@"AH_1"]) {
            NSString *shareUrl = [NSString stringWithFormat:kShareActivityURL,kHtmlEnvironmentalKey,YDNoNilNumber(self.activity.aid)];
            AWActionSheet *sheet = [AWActionSheet actionSheetWithTouchItemBlock:^(YDClickSharePlatformType index) {
                [YDShareManager shareToPlatform:index
                                          title:param[@"title"] ? : @"遇道"
                                        content:param[@"con"] ? : @"分享 @遇道"
                                            url:shareUrl
                                     thumbImage:param[@"img"] ? : YDImage(@"YuDaoLogo")
                                          image:param[@"img"] ? : YDImage(@"YuDaoLogo")
                                   musicFileURL:nil
                                        extInfo:nil
                                       fileData:nil
                                   emoticonData:nil
                                       latitude:0.0
                                      longitude:0.0
                                       objectID:nil];
            }];
            [sheet show];
        }
    }];
}
//报名活动
- (void)joinActivityWithAid:(NSString *)aid{
    if (aid == nil) {
        return;
    }
    if (!YDHadLogin) {
        [self presentViewController:[YDLoginViewController new] animated:YES completion:^{
            
        }];
        return;
    }
    YDWeakSelf(self);
    [YDLoadingHUD showLoadingInView:self.view];
    NSDictionary *para = @{@"access_token":YDAccess_token,@"aid":aid};
    [YDActivityViewModel requestJoinActivityWithPara:para success:^{
        NSDictionary *param = @{
                                @"webCode":@"AH_DATA_4"
                                };
        
        NSString *methodStr = [NSString stringWithFormat:kCallHtmlMethodPrefix,[param mj_JSONString]];
        
        [weakself callJSMethod:methodStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
            [[YDUserDefault defaultUser] refreshUserInformationSuccess:nil failure:nil];
        }];
    } failure:^(NSNumber *code, NSString *status) {
        if ([code isEqual:@3015]) {
            [YDMBPTool showInfoImageWithMessage:@"已参加此活动" hideBlock:^{
                
            }];
        }
        else{
            if (status.length > 0) {
                [YDMBPTool showInfoImageWithMessage:status hideBlock:^{
                    
                }];
            }
        }
    }];
}

#pragma mark - WKScriptMessageHandler - JS调用OC方法的回调,在子控制器中覆盖此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    //点击我要报名
    if ([message.name isEqualToString:kRegisterMethodName_dataTransfer]) {
        NSDictionary *param = [message.body mj_JSONObject];
        NSString *code = [param objectForKey:@"webCode"];
        if ([code isEqualToString:@"HA_DATA_1"]) {
            [self joinActivityWithAid:[param objectForKey:@"aId"]];
        }
    }
    else if ([message.name isEqualToString:kRegisterMethodName_login]){
        if (!YDHadLogin) {
            [self presentViewController:[YDLoginViewController new] animated:YES completion:^{
                
            }];
            return;
        }
    }
    else if ([message.name isEqualToString:kRegisterMethodName_pageJump]){
        NSDictionary *param = [message.body mj_JSONObject];
        NSString *code = [param objectForKey:@"webCode"];
        if ([code isEqualToString:@"HA_PJ_5"]) {
            YDIntegralController *integralVC = [YDIntegralController new];
            [self.navigationController pushViewController:integralVC animated:YES];
        }
    }
}


@end

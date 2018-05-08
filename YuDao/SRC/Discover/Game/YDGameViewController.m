//
//  YDGameViewController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/26.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDGameViewController.h"
#import "WLHealthKitManage.h"
#import "YDUserFilesController.h"

#define kGameMatchingURL [kOriginalURL stringByAppendingString:@"gamematching"]

@interface YDGameViewController ()

@property (nonatomic, strong) WLHealthKitManage *healthManage;

@end

@implementation YDGameViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"遇道"];
    
    [self.webView setAllowsBackForwardNavigationGestures:NO];
    
    [self registerAMethodToJS:kRegisterMethodName_pageJump];
    
    [self requestCurrentUserGameStatus:^(YDGameStatus status) {
        if (status == YDGameStatusHadJoin || status == YDGameStatusCompletion) {
            [self.healthManage getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
                
                [self setUrlString:[NSString stringWithFormat:kGameHadJoinHtmlURL,kHtmlEnvironmentalKey,YDAccess_token,[YDCarHelper sharedHelper].defaultCar.ug_id,(int)value,[YDShortcutMethod appVersion]]];
            }];
        }
        else if (status == YDGameStatusNotJoin || status == YDGameStatusQuit){
            [self.healthManage getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
                
                [self setUrlString:[NSString stringWithFormat:kGameNotJoinHtmlURL,kHtmlEnvironmentalKey,YDAccess_token,[YDCarHelper sharedHelper].defaultCar.ug_id,(int)value,[YDShortcutMethod appVersion]]];
            }];
        }
        else{
            [YDMBPTool showInfoImageWithMessage:@"游戏暂未开放" hideBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
}


//查询当前用户的游戏状态,status 1：参加 2：退出 3：完成
- (void)requestCurrentUserGameStatus:(void (^)(YDGameStatus status))completion{
    [YDLoadingHUD showLoadingInView:self.view];
    NSDictionary *param = @{
                            @"access_token":YDAccess_token
                            };
    [YDNetworking GET:kGameMatchingURL parameters:param success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@200]) {
            NSNumber *status = [data objectForKey:@"status"];
            if (status == nil) {
                completion(YDGameStatusNotJoin);
            }
            else if ([status isEqual:@1]){
                completion(YDGameStatusHadJoin);
            }
            else if ([status isEqual:@2]){
                completion(YDGameStatusQuit);
            }
            else if ([status isEqual:@3]){
                completion(YDGameStatusCompletion);
            }
            else{
                completion(YDGameStatusUnknown);
            }
        }
    } failure:^(NSError *error) {
        completion(YDGameStatusUnknown);
    }];
}

#pragma mark - WKScriptMessageHandler - JS调用OC方法的回调,在子控制器中覆盖此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //点击我要报名
    if ([message.name isEqualToString:kRegisterMethodName_pageJump]) {
        NSDictionary *param = [message.body mj_JSONObject];
        NSString *code = [param objectForKey:@"webCode"];
        if ([code isEqualToString:@"HA_PJ_1"]) {
            NSString *userId = [param objectForKey:@"userId"];
            NSString *userNickName = [param objectForKey:@"userNickName"];
            //NSString *userSex = [param objectForKey:@"userSex"];
            
            YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:@(userId.integerValue)];
            viewM.userName = userNickName;
            
            YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
            [self.navigationController pushViewController:userVC animated:YES];
        }
        else if ([code isEqualToString:@"HA_PJ_2"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Getter
- (WLHealthKitManage *)healthManage{
    if (_healthManage == nil) {
        _healthManage = [WLHealthKitManage manager];
    }
    return _healthManage;
}

@end

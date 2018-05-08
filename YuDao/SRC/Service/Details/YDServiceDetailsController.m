//
//  YDServiceDetailsController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDServiceDetailsController.h"
#import "YDPayManager.h"

@interface YDServiceDetailsController ()

//将要进入的商品id
@property (nonatomic, copy  ) NSString *currentGoodsId;

@end

@implementation YDServiceDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"加载中..."];
    
    //开启返回按钮
    self.disableBackButton = NO;
    
    //注册给js用的方法
    [self registerAMethodToJS:kRegisterMethodName_login];
    [self registerAMethodToJS:kRegisterMethodName_dataTransfer];
    [self registerAMethodToJS:kRegisterMethodName_pageJump];
    
    [[YDUserDefault defaultUser] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //支付完成通知
    [YDNotificationCenter addObserver:self selector:@selector(service_PayCompltionNotificationAction:) name:kService_PayCompltionNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)dealloc{
    
    YDLog(@"子类 dealloc");
    [YDNotificationCenter removeObserver:self name:kService_PayCompltionNotification object:nil];
    [[YDUserDefault defaultUser] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - Events

#pragma mark - kService_PayCompltionNotification Action
- (void)service_PayCompltionNotificationAction:(NSNotification *)noti{
    NSString *orderid = [noti.object objectForKey:@"orderid"];
    NSString *payStatus = [noti.object objectForKey:@"payStatus"];
    NSDictionary *param = @{
                            @"webCode":@"AH_DATA_1",
                            @"orderNo":YDNoNilString(orderid),
                            @"payStatus":YDNoNilString(payStatus)
                            };
    YDLog(@"orderid = %@,payStatus = %@",orderid,payStatus);
    
    //如果支付成功，回到商城首页
    [self callJSMethod:[NSString stringWithFormat:kCallHtmlMethodPrefix,[param mj_JSONString]] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        YDLog(@"调JS支付完成的回调... obj = %@",obj);
    }];
}

#pragma mark - YDUserDefaultDelegate
- (void)defaultUserAlreadyLogged:(YDUser *)user{
    NSNumber *channelId = [YDCarHelper sharedHelper].defaultCar.channelid;
    NSDictionary *param = @{
                            @"webCode":@"AH_DATA_2",
                            @"userId": [NSString stringWithFormat:@"%@",YDNoNilNumber(YDUser_id)],
                            @"channelId": [NSString stringWithFormat:@"%@",YDNoNilNumber(channelId)],
                            @"goodsId": YDNoNilString(self.currentGoodsId)
                            };
    
    NSString *methodStr = [NSString stringWithFormat:kCallHtmlMethodPrefix,[param mj_JSONString]];
    [self callJSMethod:methodStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
}

- (void)defaultUserExitingLogin{
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if (message == nil || message.body == nil) {
        return;
    }
    NSDictionary *param = [message.body mj_JSONObject];
    NSString *code = [param objectForKey:@"webCode"];
    if ([message.name isEqualToString:kRegisterMethodName_login]) {
        if ([code isEqualToString:@"HA_LOGIN_1"]) {
            self.currentGoodsId = [param objectForKey:@"goodsId"];
            if (YDHadLogin) {
                [self defaultUserAlreadyLogged:[YDUserDefault defaultUser].user];
            }
            else{
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }
        }
    }
    else if ([message.name isEqualToString:kRegisterMethodName_dataTransfer]) {
        if ([code isEqualToString:@"HA_DATA_3"]) {
            NSDictionary *payParam = @{
                                       @"ub_id":YDNoNilString([param objectForKey:@"ubId"]),
                                       @"orderid":YDNoNilString([param objectForKey:@"orderId"]),
                                       @"orderprice":YDNoNilString([param objectForKey:@"orderPrice"]),
                                       @"goodsname":YDNoNilString([param objectForKey:@"goodsName"]),
                                       @"goodsdescription":YDNoNilString([param objectForKey:@"goodsDescription"])
                                       };
            
            [YDPayManager alipayWithPara:payParam success:nil failure:^{
                [YDMBPTool showInfoImageWithMessage:@"调起支付失败" hideBlock:^{
                    
                }];
            }];
        }
    }
    else if ([message.name isEqualToString:kRegisterMethodName_pageJump]) {
        NSDictionary *param = [message.body mj_JSONObject];
        NSString *code = [param objectForKey:@"webCode"];
        if ([code isEqualToString:@"HA_PJ_6"]) {
            [self clearWebViewCache];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end

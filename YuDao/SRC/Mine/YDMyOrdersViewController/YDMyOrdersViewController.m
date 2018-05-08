//
//  YDMyOrdersViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMyOrdersViewController.h"
#import "YDPayManager.h"

@interface YDMyOrdersViewController ()

@end

@implementation YDMyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的订单"];
    
    //开启返回按钮
    self.disableBackButton = NO;
    
    NSString *url = [NSString stringWithFormat:kOrdersHtmlURL,kHtmlEnvironmentalKey,YDUser_id,[YDShortcutMethod appVersion]];
    [self setUrlString:url];
    [self registerAMethodToJS:kRegisterMethodName_dataTransfer];
    [self registerAMethodToJS:kRegisterMethodName_pageJump];
    
    //增加支付完成监听
    [YDNotificationCenter addObserver:self selector:@selector(service_PayCompltionNotificationAction:) name:kService_PayCompltionNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)dealloc{
    [YDNotificationCenter removeObserver:self name:kService_PayCompltionNotification object:nil];
}

#pragma mark - kService_PayCompltionNotification Action - 支付完成
- (void)service_PayCompltionNotificationAction:(NSNotification *)noti{
    NSString *orderid = [noti.object objectForKey:@"orderid"];
    NSString *payStatus = [noti.object objectForKey:@"payStatus"];
    NSDictionary *param = @{
                            @"webCode":@"AH_DATA_1",
                            @"orderNo":YDNoNilString(orderid),
                            @"payStatus":YDNoNilString(payStatus)
                            };
    NSLog(@"orderid = %@,payStatus = %@",orderid,payStatus);
    
    //如果支付成功，回到商城首页
    [self callJSMethod:[NSString stringWithFormat:kCallHtmlMethodPrefix,[param mj_JSONString]] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"调JS支付完成的回调... obj = %@",obj);
    }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:kRegisterMethodName_dataTransfer]) {
        NSDictionary *param = [message.body mj_JSONObject];
        NSString *code = [param objectForKey:@"webCode"];
        if ([code isEqualToString:@"HA_DATA_3"]) {
            NSDictionary *payParam = @{
                                       @"ub_id":YDNoNilString([param objectForKey:@"ubId"]),
                                       @"orderid":YDNoNilString([param objectForKey:@"orderId"]),
                                       @"orderprice":YDNoNilString([param objectForKey:@"orderPrice"]),
                                       @"goodsname":YDNoNilString([param objectForKey:@"goodsName"]),
                                       @"goodsdescription":YDNoNilString([param objectForKey:@"goodsDescription"])
                                       };
            
            [YDPayManager alipayWithPara:payParam success:nil failure:^{
                [YDMBPTool showErrorImageWithMessage:@"订单错误" hideBlock:^{
                    
                }];
            }];
        }
    }
    else if ([message.name isEqualToString:kRegisterMethodName_pageJump]){
        
    }
}

@end

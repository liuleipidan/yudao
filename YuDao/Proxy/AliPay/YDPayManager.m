//
//  YDPayManager.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPayManager.h"
#import <AlipaySDK/AlipaySDK.h>

#define kAlipayScheme @"YDAlipay"  //支付宝scheme

#define kAliPayResultStatusSuccess @"9000" //支付成功

#define kAliPayResultStatusFail    @"4000" //支付失败

#define kAliPayResultStatusCancel  @"6001" //支付取消/已支付

static NSNumber *kOrderid = nil;

@implementation YDPayManager

+ (void)alipayWithPara:(NSDictionary *)para
               success:(void (^)(void))suceess
               failure:(void (^)(void))failure{
    [YDLoadingHUD showLoading];
    
    NSString *urlStr = [kOriginalURL stringByAppendingString:@"alipay"];
    kOrderid = [para objectForKey:@"orderid"];
    
    [YDNetworking GET:urlStr parameters:para success:^(NSNumber *code, NSString *status, id data) {
        
        if ([code isEqual:@200] && data) {
            //网页版支付宝支付完回调
            [[AlipaySDK defaultService] payOrder:data fromScheme:kAlipayScheme callback:^(NSDictionary *resultDic) {
                YDLog(@"支付结果 result = %@",resultDic);
                if (kOrderid) {
                    [YDPayManager pm_postPayComplationNotificationByOrderId:kOrderid resultDictionary:resultDic];
                }
            }];
        }else{
            failure();
        }
    } failure:^(NSError *error) {
        
        failure();
    }];
    
}

//广播支付完成/失败的通知
+ (void)pm_postPayComplationNotificationByOrderId:(id)orderId resultDictionary:(NSDictionary *)resultDic{
    NSMutableDictionary *payCompletionPara = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                             @"orderid":[NSString stringWithFormat:@"%@",orderId]
                                                                                             }];
    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
        //支付成功
    if ([resultStatus isEqual:kAliPayResultStatusSuccess]) {
        [payCompletionPara setObject:@"1" forKey:@"payStatus"];
    }
    else{
        //支付失败
        [payCompletionPara setObject:@"0" forKey:@"payStatus"];
    }
    
    kOrderid = nil;
    [YDNotificationCenter postNotificationName:kService_PayCompltionNotification object:payCompletionPara];
}

+ (void)alipayCallback:(NSURL *)url{

    //支付跳转支付宝钱包进行支付，处理支付结果(APP)
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        if (kOrderid) {
            [YDPayManager pm_postPayComplationNotificationByOrderId:kOrderid resultDictionary:resultDic];
        }
    }];
    
    //授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        YDLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
    
}

@end

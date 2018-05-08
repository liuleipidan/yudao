//
//  YDURLHandle.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDURLHandle.h"
#import "YDPayManager.h"
#import "YDRankListViewController.h"
#import "YDActivityViewController.h"
#import "YDActivityWebController.h"
#import "YDAllDynamicController.h"
#import "YDDynamicDetailsController.h"

@implementation YDURLHandle

//处理被其他app打开回调
+ (void)handleOpenURL:(NSURL *)url{
    //支付宝回调(必要)
    if ([url.host isEqualToString:@"safepay"]) {
        [YDPayManager alipayCallback:url];
    }
    
    //通过Widget启动app
    if ([url.scheme isEqualToString:@"YuDaoWidget"]) {
        //功能为行车信息
        if ([url.host isEqualToString:@"carInformation"]) {
            //具体功能展示（0->历程，1->百公里油耗,2->车辆评分）
            switch (url.query.integerValue) {
                case 0:
                    YDLog(@"里程");
                    break;
                case 1:
                    YDLog(@"油耗");
                    break;
                case 2:
                    YDLog(@"评分");
                    break;
                default:
                    break;
            }
        }
    }
    else if ([url.scheme isEqualToString:@"ydweb"]){
        NSDictionary *para = [NSString yd_paramForURLQuery:url.query];
        if (para) {
            
            NSString *module = [para objectForKey:@"module"];
            if ([module isEqualToString:@"rank"]) {//排行榜
                [[YDRootViewController sharedRootViewController] releaseNavigationControllerAndShowViewControllerWithIndex:0];
                YDNavigationController *naviVC = [YDRootViewController sharedRootViewController].selectedViewController;
                NSString *type = [para objectForKey:@"type"];
                YDRankListViewController *rankVC = [YDRankListViewController new];
                [rankVC setInitLoadController:type.integerValue-1];
                [naviVC pushViewController:rankVC animated:YES];
            }else{
                [[YDRootViewController sharedRootViewController] releaseNavigationControllerAndShowViewControllerWithIndex:1];
                YDNavigationController *naviVC = [YDRootViewController sharedRootViewController].selectedViewController;
                if ([module isEqualToString:@"activity"]){//活动详情
                    NSString *aid = [para objectForKey:@"aid"];
                    [naviVC pushViewController:[YDActivityViewController new] animated:NO];
                    YDActivityWebController *webVC = [[YDActivityWebController alloc] init];
                    YDActivity *activity = [YDActivity new];
                    activity.aid = @(aid.integerValue);
                    [webVC setActivity:activity];
                    [webVC setNeedGetActivityDetails:YES];
                    [naviVC pushViewController:webVC animated:YES];
                }
                else if ([module isEqualToString:@"dynamic"]){//动态详情
                    NSString *did = [para objectForKey:@"did"];
                    [naviVC pushViewController:[YDAllDynamicController new] animated:NO];
                    YDDynamicDetailViewModel *dyViewModel = [[YDDynamicDetailViewModel alloc] initWithDynamicId:@(did.integerValue)];
                    YDDynamicDetailsController *detailVC = [[YDDynamicDetailsController alloc] initWithViewModel:dyViewModel];
                    [naviVC pushViewController:detailVC animated:YES];
                }
                else if ([module isEqualToString:@"report"]){//周报
                    
                }
            }
            
            
        }
    }
}


@end

//
//  AppDelegate+Category.m
//  YuDao
//
//  Created by 汪杰 on 17/3/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "AppDelegate+Category.h"


@implementation AppDelegate (Category)

- (void)startNetworkMonitoring{
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.networkStatus = (YDReachabilityStatus)status;
        
        //未知网络
        if (status == AFNetworkReachabilityStatusUnknown) {
            YDLog(@"%s -- %@",__func__,@"未知网络");
        }
        //网络不可用
        else if (status == AFNetworkReachabilityStatusNotReachable){
            YDLog(@"%s -- %@",__func__,@"网络不可用");
            [UIAlertController YD_OK_AlertController:[YDRootViewController sharedRootViewController] title:@"当前网络不可用\n请检查你的网络设置" clickBlock:^{
                
            }];
        }
        //蜂窝网络
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            YDLog(@"%s -- %@",__func__,@"蜂窝网络");
        }
        //WIFI
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            YDLog(@"%s -- %@",__func__,@"WIFI");
        }
    }];
    
    [reachabilityManager startMonitoring];
}

//MARK:检查版本更新
- (void)checkVersionUpdate{
    //检测更新
    NSString *url = [kAPPStoreURL stringByAppendingString:kAppID];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {;
        /*responseObject是个字典{}，有两个key
         KEYresultCount = 1//表示搜到一个符合你要求的APP
         results =（）//这是个只有一个元素的数组，里面都是app信息，那一个元素就是一个字典。
            {trackCensoredName = 审查名称;
            trackContentRating = 评级;
            trackId = 应用程序 ID;
            trackName = 应用程序名称;
            trackViewUrl = 应用程序介绍网址;
            userRatingCount = 用户评级;
            userRatingCountForCurrentVersion = 1;
            version = 版本号;}
         */
        
        NSArray *arr = [responseObject objectForKey:@"results"];
        if (arr.count != 0) {
            NSDictionary *dic = [arr firstObject];
            NSString *versionStr = [dic objectForKey:@"version"];
            NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
            NSString *releaseNotes = [dic objectForKey:@"releaseNotes"];//更新日志
            
            NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            if ([self compareVersionsFormAppStore:versionStr WithAppVersion:thisVersion]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIAlertController YD_alertController:nil
                                                    title:[NSString stringWithFormat:@"发现新版本:%@",versionStr]
                                                 subTitle:releaseNotes
                                                    items:@[@"立即更新"]
                                                    style:UIAlertControllerStyleAlert
                                               clickBlock:^(NSInteger index) {
                                                   if (index ==1 ) {
                                                       NSURL * url = [NSURL URLWithString:trackViewUrl];//itunesURL = trackViewUrl的内容
                                                       [[UIApplication sharedApplication] openURL:url];
                                                   }
                    }];
                });
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//MARK:比较版本,用Version来比较的
- (BOOL)compareVersionsFormAppStore:(NSString*)AppStoreVersion WithAppVersion:(NSString*)AppVersion{
    
    BOOL littleSunResult = false;
    
    NSMutableArray* a = (NSMutableArray*) [AppStoreVersion componentsSeparatedByString: @"."];
    NSMutableArray* b = (NSMutableArray*) [AppVersion componentsSeparatedByString: @"."];
    
    while (a.count < b.count) { [a addObject: @"0"]; }
    while (b.count < a.count) { [b addObject: @"0"]; }
    
    for (int j = 0; j<a.count; j++) {
        if ([[a objectAtIndex:j] integerValue] > [[b objectAtIndex:j] integerValue]) {
            littleSunResult = true;
            break;
        }else if([[a objectAtIndex:j] integerValue] < [[b objectAtIndex:j] integerValue]){
            littleSunResult = false;
            break;
        }else{
            littleSunResult = false;
        }
    }
    return littleSunResult;//true就是有新版本，false就是没有新版本
    
}

@end

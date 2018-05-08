//
//  YDLoadingHUD.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/12.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDProgressHUD.h"

//网络请求完成通知name
static NSString *const kLoadingHUDRequsetCompletion = @"kLoadingHUDRequsetCompletion";

//最长显示时间
static NSTimeInterval const kLoadingHUDLongestShowTime = 10.0f;

//自定义加载中视图
@interface YDLoadingHUD : NSObject

+ (YDProgressHUD *)showLoading;

+ (YDProgressHUD *)showLoadingInView:(UIView *)view;

+ (void)hide;

@end

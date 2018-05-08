//
//  YDActivityWebController.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDWKWebViewController.h"
#import "YDActivityViewModel.h"


@interface YDActivityWebController : YDWKWebViewController

@property (nonatomic, strong) YDActivity *activity;

/**
 是否需要请求活动详情，目前是用在通过分享出去的活动打开此App
 */
@property (nonatomic, assign) BOOL needGetActivityDetails;

@end

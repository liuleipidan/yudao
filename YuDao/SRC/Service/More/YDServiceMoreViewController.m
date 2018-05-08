//
//  YDServiceMoreViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDServiceMoreViewController.h"

@interface YDServiceMoreViewController ()

@end

@implementation YDServiceMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"navigation_back_image" target:self action:@selector(sm_backNavigationItemAction:)];
    
    //开启返回按钮
    self.disableBackButton = NO;
    
    YDCarDetailModel *car = [YDCarHelper sharedHelper].defaultCar;
    NSString *url = [NSString stringWithFormat:kServiceMoreURL,kMallEnvironmentalKey,car ? car.channelid : @0,YDUser_id];
    YDLog(@"more service url = %@",url);
    [self setUrlString:url];
}

- (void)sm_backNavigationItemAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webClickCompletionHandle{
    [self clearWebViewCache];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navBackButotnDown{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem fixItemSpace:-WEBVIEW_NAVBAR_ITEMS_FIXED_SPACE], self.backButtonItem, self.closeButtonItem]];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)navCloseButtonDown{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

//
//  YDUseProtocolViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUseProtocolViewController.h"

@interface YDUseProtocolViewController ()

@end

@implementation YDUseProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"用户使用协议"];
    
    self.useMPageTitleAsNavTitle = NO;
    NSString *url = [NSString stringWithFormat:kUserProtocolHtmlURL,kHtmlEnvironmentalKey,[YDShortcutMethod appVersion]];
    [self setUrlString:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  WJPrivilegeSettingController.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/23.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "WJPrivilegeSettingController.h"
#import "WJGoSettingView.h"

@interface WJPrivilegeSettingController ()

@property (nonatomic, strong) WJGoSettingView *settingView;

@end

@implementation WJPrivilegeSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settingView = [[WJGoSettingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_settingView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

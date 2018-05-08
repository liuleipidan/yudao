//
//  YDSelfNavigationBarViewController.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSelfNavigationBarViewController.h"

@interface YDSelfNavigationBarViewController ()

//记录上一个控制器导航栏是否隐藏
@property (nonatomic, assign) BOOL previousViewControllerNavigationBarHidden;

//记录上一个状态栏样式
@property (nonatomic, assign) UIStatusBarStyle previousViewControllerStatusBarStyle;

@end

@implementation YDSelfNavigationBarViewController

@synthesize navigationBar = _navigationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.navigationBar];
    [self.view bringSubviewToFront:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(STATUSBAR_HEIGHT + NAVBAR_HEIGHT);
    }];
    
}

- (void)dealloc{
    YDLog();
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _previousViewControllerNavigationBarHidden = self.navigationController.navigationBar.hidden;
    
    if (!_previousViewControllerNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    self.previousViewControllerStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    if ([UIApplication sharedApplication].statusBarStyle != self.statusBarStyle) {
        
        [[UIApplication sharedApplication] yd_setStatusBarStyle:self.statusBarStyle];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (!_previousViewControllerNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    if ([UIApplication sharedApplication].statusBarStyle != self.previousViewControllerStatusBarStyle) {
        [[UIApplication sharedApplication] yd_setStatusBarStyle:self.previousViewControllerStatusBarStyle];
    }
}

#pragma mark - Getters
- (YDNavigationBar *)navigationBar{
    if (_navigationBar == nil) {
        _navigationBar = [[YDNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    }
    return _navigationBar;
}

@end

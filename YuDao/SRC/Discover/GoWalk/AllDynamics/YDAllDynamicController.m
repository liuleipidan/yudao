//
//  YDAllDynamicController.m
//  YuDao
//
//  Created by 汪杰 on 16/12/22.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDAllDynamicController.h"
#import "YDContainerController.h"
#import "YDMomentViewController.h"
#import "YDPublishDynamicController.h"

@interface YDAllDynamicController ()<YDPublishDynamicControllerDelegate,YDContainerControllerDelegate,UINavigationControllerDelegate,YDMomentViewControllerDelegate>

@property (nonatomic, strong) YDContainerController *containerVC;

/**
 最新动态
 */
@property (nonatomic, strong) YDMomentViewController *newestVC;

/**
 附近动态
 */
@property (nonatomic, strong) YDMomentViewController *nearbyVC;

/**
 好友动态
 */
@property (nonatomic, strong) YDMomentViewController *friendVC;

/**
 当前正在显示的controller
 */
@property (nonatomic, strong) YDMomentViewController *currentVC;

@end

@implementation YDAllDynamicController

static YDAllDynamicController *allDyVC = nil;
+ (YDAllDynamicController *)sharedAlldynamicVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allDyVC = [[YDAllDynamicController alloc] init];
    });
    return allDyVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"逛一逛"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"dynamic_button_add" target:self action:@selector(allDynamicRightBarItem:)];
    
    [self.view addSubview:self.containerVC.view];

}

- (void)dealloc{
    NSLog(@"dealloc:class = %@",NSStringFromClass(self.class));
}

- (void)setFromFlag:(NSInteger)fromFlag{
    _fromFlag = fromFlag;
    
    if (_fromFlag == 1) {
        UIBarButtonItem *leftBarItem = [UIBarButtonItem itemWithImage:@"navigation_back_image" target:self action:@selector(allDynamicLeftBarItem:)];
        [self.navigationItem setLeftBarButtonItem:leftBarItem];
    }else{
        [self.navigationItem setLeftBarButtonItem:nil];
    }
}

- (void)allDynamicLeftBarItem:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)allDynamicRightBarItem:(id)sender{
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"未登录" hideBlock:^{
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    YDPublishDynamicController *pdVC = [YDPublishDynamicController new];
    pdVC.delegate = self;
    [self presentViewController:[YDNavigationController createNaviByRootController:pdVC] animated:YES completion:nil];
}
#pragma mark - YDPublishDynamicControllerDelegate
//发布了新动态
- (void)publishDynamicController:(YDPublishDynamicController *)controller publishedNewDynamic:(NSNumber *)userId{
    [self.newestVC.tableView.mj_header beginRefreshing];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    //当分栏隐藏时，滑动改变导航栏title
    if (self.containerVC.view.y == -64) {
        [self.navigationItem setTitle:controller.title];
    }
    //好友动态需要用户登录
    YDMomentViewController *currentVC = (YDMomentViewController *)controller;
    if (currentVC.vcType == YDGowalkViewControllerTypeFriend) {
        if (!YDHadLogin) {
            [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
                [currentVC.momentProxy.moments removeAllObjects];
                [currentVC.tableView reloadData];
                [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
            }];
        }else{
            [currentVC mc_headerAction];
        }
    }
    
    if (_currentVC != controller) {
        NSLog(@"切换控制器了");
        [_currentVC viewWillDisappear:NO];
        _currentVC = (id)controller;
    }
    
}

#pragma mark  - YDMomentViewControllerDelegate
- (void)momentViewController:(YDMomentViewController *)controller didScrollOffsetY:(CGFloat )offsetY{
    [self scrollToChangeTitle:controller.title offsetY:offsetY];
}

//滑动改变导航栏标题
- (void)scrollToChangeTitle:(NSString *)title offsetY:(CGFloat )y{
    self.containerVC.view.y = -(y);
    if (self.containerVC.view.y < -64) {
        self.containerVC.view.y = -64;
    }
    if (self.containerVC.view.y > 0) {
        self.containerVC.view.y = 0;
    }
    
    self.containerVC.view.height += y;
    self.containerVC.view.autoresizesSubviews = YES;
    CGFloat alpha = 1-(y/100 * 2.5);
    if (alpha < 0) {
        self.containerVC.view.height = SCREEN_HEIGHT;
        alpha = 0;
    }
    if (alpha > 1) {
        self.containerVC.view.height = SCREEN_HEIGHT-64;
        self.containerVC.view.y = 0;
        alpha = 1;
    }
    self.containerVC.menuView.alpha = alpha;
    
    if (y>40) {
        self.title = title;
    }
    if (y<0) {
        self.title = @"逛一逛";
    }
}

#pragma mark - Getters
- (YDContainerController *)containerVC{
    if (!_containerVC) {
        
        _newestVC = [[YDMomentViewController alloc] initWithType:YDGowalkViewControllerTypeNewest];
        _newestVC.delegate = self;
        _newestVC.title = @"最新";
        _nearbyVC = [[YDMomentViewController alloc] initWithType:YDGowalkViewControllerTypeNearby];
        _nearbyVC.delegate = self;
        _nearbyVC.title = @"附近";
        _friendVC = [[YDMomentViewController alloc] initWithType:YDGowalkViewControllerTypeFriend];
        _friendVC.delegate = self;
        _friendVC.title = @"好友";
        NSArray *viewcontrollers = @[_newestVC,_nearbyVC,_friendVC];
        
        YDContainerController *containerVC = [[YDContainerController alloc] initWithControllers:viewcontrollers topBarHeight:[[UIApplication sharedApplication] statusBarFrame].size.height + NAVBAR_HEIGHT parentController:self];
        containerVC.delegate = self;
        containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
        containerVC.menuItemTitleColor = [UIColor colorWithString:@"#F2B3552"];
        containerVC.scrollMenuViewHeight = 46.f;
        containerVC.menuView.indicatorWidth = 37.0f;
        //containerVC.view.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
        _containerVC = containerVC;
        _currentVC = _newestVC;
    }
    return _containerVC;
}

@end

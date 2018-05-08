//
//  YDNavigationController.m
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDNavigationController.h"

@interface YDNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property(nonatomic,weak) UIViewController* currentShowVC;

/**
 状态视图，防止navigationBar偏移导致_UIBarBackground高度减少
 */
@property (nonatomic, strong) UIView *statusView;

@end

@implementation YDNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    YDNavigationController* nvc = [super initWithRootViewController:rootViewController];
    self.interactivePopGestureRecognizer.delegate = self;
    nvc.delegate = self;
    return nvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景色
    [self.navigationBar setBackgroundImage:YDImage(@"navigation_bar_backgroud") forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    //文字颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //假装状态栏
    [self.navigationBar addSubview:self.statusView];
    //系统版本低于11不可用自动布局，会奔溃
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.navigationBar);
            make.top.equalTo(self.navigationBar).offset(-STATUSBAR_HEIGHT);
            make.height.mas_equalTo(STATUSBAR_HEIGHT);
        }];
    }
}

- (void)navCustomBackButtonPressed
{
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //隐藏tabBar
    if (self.childViewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //统一返回按钮
    if (self.childViewControllers.count > 0) {
        UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:@"navigation_back_image" target:self action:@selector(nc_backBarButtonItemAction:)];
        viewController.navigationItem.leftBarButtonItem = leftItem;
    }
    [super pushViewController:viewController animated:animated];
}

//点击返回按钮
- (void)nc_backBarButtonItemAction:(UIBarButtonItem *)sender{
    
    [self popViewControllerAnimated:YES];
}

#pragma mark - Public Methods
+ (YDNavigationController *)createNaviByRootController:(id)rootVC{
    if (rootVC == nil) {
        return nil;
    }
    YDNavigationController *navi = [[YDNavigationController alloc] initWithRootViewController:rootVC];
    return navi;
}


#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (navigationController.viewControllers.count == 1){
        self.currentShowVC = Nil;
    }
    else{
        self.currentShowVC = viewController;
    }
}

#pragma mark - UIGestureRecognizerDelegate
//截取右滑返回手势，当为我的资料页面时，上传用户信息
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController); //the most important
    }
    return YES;
}

#pragma mark - Getters
- (UIView *)statusView{
    if (_statusView == nil) {
        _statusView = [UIView new];
        _statusView.backgroundColor = [UIColor baseColor];
        _statusView.frame = CGRectMake(0, -STATUSBAR_HEIGHT, SCREEN_WIDTH, STATUSBAR_HEIGHT);
    }
    return _statusView;
}

@end

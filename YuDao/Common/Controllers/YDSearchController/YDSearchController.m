//
//  YDSearchController.m
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDSearchController.h"

@interface YDSearchController ()<UISearchControllerDelegate>

//用来控制背景色的视图
@property (nonatomic, strong) UIView *bgColorView;

//控制statusBar的颜色
@property (nonatomic, strong) UIView *statusBarView;

@end

@implementation YDSearchController

- (id)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        
        [self setupSearchBar];
        
        [self setDelegate:self];
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [YDNotificationCenter addObserver:self selector:@selector(sc_tableViewDidScrollNotification:) name:kSearchResultTableViewDidScrollNotification object:nil];
    
    [self.view insertSubview:self.statusBarView belowSubview:self.searchBar];

    [self.statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(STATUSBAR_HEIGHT + self.searchBar.height);
    }];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //关闭侧边右滑返回
    self.presentingViewController.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //开启侧边右滑返回
    self.presentingViewController.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

- (void)dealloc{
    
    [YDNotificationCenter removeObserver:self];
}

#pragma mark - Private Methods
- (void)sc_tableViewDidScrollNotification:(NSNotification *)noti{
    
    [self.searchBar endEditing:YES];
}

//设置searchBar
- (void)setupSearchBar{
    if (@available(iOS 11.0, *)) {
        //[self.searchBar setPositionAdjustment:UIOffsetMake(SCREEN_WIDTH/2.0, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
    
    self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, SEARCHBAR_HEIGHT);

    //修改背景色，这里其实修改了也没用，会有一层UISearchBarBackground在其上面
    self.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor searchBarBackgroundColor]];

    //
    self.searchBar.barTintColor = [UIColor searchBarBackgroundColor];

    //同时修改“取消”和“抖动的竖线”的颜色
    //[self.searchBar setTintColor:[UIColor blackTextColor]];
    
    //修改取消按钮的文字和颜色
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
    
    //占位文字
    [self.searchBar setPlaceholder:kSBDefaultPlaceholder];

    //修改textField
    UITextField *tf = [self.searchBar valueForKey:@"_searchField"];
    [tf.layer setMasksToBounds:YES];
    [tf.layer setCornerRadius:3.0f];

    //边框
//    [tf.layer setBorderWidth:BORDER_WIDTH_1PX];
//    [tf.layer setBorderColor:[UIColor clearColor].CGColor];

    for (UIView *view in self.searchBar.subviews[0].subviews) {
        //修改背景色
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            UIView *bgView = [UIView new];
            bgView.backgroundColor = [UIColor searchBarBackgroundColor];
            [view addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            _bgColorView = bgView;
            //break;
        }
    }
    
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(searchControllerWillPresent:)]) {
        [self.customDelegate searchControllerWillPresent:self];
    }
    
    //修改背景色
    [_bgColorView setBackgroundColor:[UIColor baseColor]];
    [_statusBarView setBackgroundColor:[UIColor baseColor]];
}

- (void)didPresentSearchController:(UISearchController *)searchController{
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(searchControllerDidPresent:)]) {
        [self.customDelegate searchControllerDidPresent:self];
    }
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    //复原背景色，不加动画的话看起来会像是有抖动
    [UIView animateWithDuration:0.25 animations:^{
        [self.statusBarView setBackgroundColor:[UIColor clearColor]];
        [self.bgColorView setBackgroundColor:[UIColor searchBarBackgroundColor]];
    }];
    
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(searchControllerWillDismiss:)]) {
        [self.customDelegate searchControllerWillDismiss:self];
    }
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(searchControllerDidDismiss:)]) {
        [self.customDelegate searchControllerDidDismiss:self];
    }
}

- (UIView *)statusBarView{
    if (_statusBarView == nil) {
        _statusBarView = [UIView new];
        _statusBarView.backgroundColor = [UIColor clearColor];
    }
    return _statusBarView;
}

@end

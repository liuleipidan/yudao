//
//  TSLaunchViewController.m
//  demo
//
//  Created by wangyz on 16/4/21.
//  Copyright © 2016年 topsports2. All rights reserved.
//

#import "YDLaunchViewController.h"
#import "YDRootViewController.h"


@interface YDLaunchViewController ()<UIScrollViewDelegate>

{
    NSArray *_imgArr;//存放滚动图片的数组
}

@property (nonatomic, strong) UIScrollView *scrollView;//滚动视图
@property (nonatomic, strong) UIPageControl *pageControl;//滚动点

@end

@implementation YDLaunchViewController

#pragma mark - 控制器周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    /**
     *引动页中图片的设置
     */
    _imgArr = @[@"first_launchImage_1", @"first_launchImage_2", @"first_launchImage_3", @"first_launchImage_4"];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _imgArr.count, SCREEN_HEIGHT);
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = NO;
        
        [self addImageViewONScrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT*15/16, SCREEN_WIDTH/3, SCREEN_HEIGHT/16))];
        _pageControl.numberOfPages = _imgArr.count;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = YDBaseColor;
        [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)pageControlAction:(UIPageControl *)page{
    [_scrollView setContentOffset:CGPointMake(page.currentPage*SCREEN_WIDTH, 0) animated:YES];
}

#pragma mark - scrollView

/**
 *  在scrollView上添加图片
 */

- (void)addImageViewONScrollView {
    for (int i = 0; i < _imgArr.count; i++) {
        UIImage *img = [UIImage imageNamed:_imgArr[i]];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        if (i  == _imgArr.count - 1) {
            imgView.userInteractionEnabled = YES;
            
            //在滚动页最后一页添加按钮
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            button.frame = CGRectMake((SCREEN_WIDTH-kWidth(226))/2, SCREEN_HEIGHT - kHeight(42)-41, kWidth(226), kHeight(42));
            button.layer.borderWidth = 2;
            button.layer.cornerRadius = kHeight(42)/2;
            button.layer.borderColor = YDBaseColor.CGColor;
            [button setTitle:@"即刻开启遇道之旅" forState:0];
            [button setTitleColor:YDBaseColor forState:0];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(go:) forControlEvents:(UIControlEventTouchUpInside)];
            [imgView addSubview:button];
            
            //添加左滑手势
            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(go:)];
            [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
            [imgView addGestureRecognizer:swipe];
            
            UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
            [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
            [imgView addGestureRecognizer:rightSwipe];
        }
        
        imgView.image = img;
        [_scrollView addSubview:imgView];
    }
}

- (void)rightSwipe:(UIGestureRecognizer *)swipe{
    CGPoint offset = _scrollView.contentOffset;
    offset.x -= SCREEN_WIDTH;
    [_scrollView setContentOffset:offset animated:YES];
}

//代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
    switch (self.pageControl.currentPage) {
        case 1:
        {
            //[YDPrivilegeManager checkPrivilegeByType:YDPrivilegeTypeAddressBook compeletion:nil];
            break;}
        case 2:
        {
            //[YDPrivilegeManager checkPrivilegeByType:YDPrivilegeTypeMicrophone compeletion:nil];
            break;}
        case 3:
        {
            //[YDPrivilegeManager checkPrivilegeByType:YDPrivilegeTypePhotoLibrary compeletion:nil];
            break;}
        default:
            break;
    }
}

/**
 *  点击按钮方法
 */
- (void)go:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:YES forKey:@"isFirst"];
    [user synchronize];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [YDRootViewController sharedRootViewController];
    
    UIViewController *mainVC = [YDRootViewController sharedRootViewController].childViewControllers.firstObject;
    
    mainVC.view.alpha = 0;
    [YDRootViewController sharedRootViewController].tabBar.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        mainVC.view.alpha = 1;
        [YDRootViewController sharedRootViewController].tabBar.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}


@end

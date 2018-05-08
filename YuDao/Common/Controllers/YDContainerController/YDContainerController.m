//
//  ContainerController.m
//  YuDao
//
//  Created by 汪杰 on 16/9/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDContainerController.h"

//默认菜单栏高度
#define kScrollMenuViewHeight 46.0f

@interface YDContainerController ()<YSLScrollMenuViewDelegate,UIScrollViewDelegate>

@end

@implementation YDContainerController

- (id)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
         parentController:(UIViewController *)parentController{
    if (self = [super init]) {
        [parentController addChildViewController:self];
        [self didMoveToParentViewController:parentController];
        
        _topBarHeight = topBarHeight;
        _titles = [NSMutableArray arrayWithCapacity:controllers.count];
        _childControllers = [NSMutableArray arrayWithArray:controllers];
        
        for (UIViewController *vc in controllers) {
            [_titles addObject:vc.title];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutControllerSubViews:) name:UIApplicationDidChangeStatusBarFrameNotification object:[UIApplication sharedApplication]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *viewCover = [UIImageView new];
    viewCover.frame = self.view.bounds;
    [self.view addSubview:viewCover];
    
    if (self.scrollMenuViewHeight == 0) {
        self.scrollMenuViewHeight = kScrollMenuViewHeight;
    }
    
    _contentScrollView = [UIScrollView new];
    _contentScrollView.frame = CGRectMake(0,self.scrollMenuViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.scrollMenuViewHeight- _topBarHeight);
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = NO;
    
    //内容大小
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * self.childControllers.count, _contentScrollView.frame.size.height);
    
    //侧滑返回
    [_contentScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.screenEdgePanGestureRecognizer];
    
    [self.view addSubview:_contentScrollView];
    
    for (int i = 0; i < self.childControllers.count; i++) {
        id obj = self.childControllers[i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController *)obj;
            CGFloat scrollWidth = _contentScrollView.frame.size.width;
            CGFloat scrollHeght = _contentScrollView.frame.size.height;
            controller.view.frame = CGRectMake(i * scrollWidth, 0, scrollWidth, scrollHeght);
            [_contentScrollView addSubview:controller.view];
        }
    }
    
    _menuView = [[YDScrollMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.scrollMenuViewHeight)];
    
    _menuView.backgroundColor = [UIColor clearColor];
    _menuView.delegate = self;
    _menuView.viewbackgroudColor = self.menuBackgroudColor;
    _menuView.itemfont = self.menuItemFont;
    _menuView.itemTitleColor = self.menuItemTitleColor;
    _menuView.scrollView.scrollsToTop = NO;
    
    [_menuView setItemTitleArray:self.titles];
    
    [self.view addSubview:_menuView];
    
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.scrollMenuViewHeight);
    }];
    
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(_menuView.height);
    }];
    
    [_menuView setShadowView];
    
    [self scrollMenuViewSelectedIndex:0];
}

- (void)dealloc{
    [YDNotificationCenter removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)layoutControllerSubViews:(NSNotification *)noti{
    
    _topBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + NAVBAR_HEIGHT;
    
#pragma mark - 重置子视图的frame
    //内容视图
    _contentScrollView.frame = CGRectMake(0,self.scrollMenuViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.scrollMenuViewHeight- _topBarHeight);
    
    //内容大小
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * self.childControllers.count, _contentScrollView.frame.size.height);
    
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(self.menuView.height);
    }];
}


- (void)setSelectedIndex:(NSInteger )index animated:(BOOL )animated{
    
    [_contentScrollView setContentOffset:CGPointMake(index * _contentScrollView.frame.size.width, 0) animated:animated];
    
    //item color
    [_menuView setItemTextColor:self.menuItemTitleColor seletedItemTextColor:self.menuItemSelectedTitleColor currentIndex:index];
    [self setChildControllersWithCurrentIndext:index];
    
    if (index == self.currentIndex) { return; }
    self.currentIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerViewItemIndex:currentController:)]) {
        [self.delegate containerViewItemIndex:self.currentIndex currentController:_childControllers[self.currentIndex]];
    }
}

#pragma mark -- private
- (void)setChildControllersWithCurrentIndext:(NSInteger)currentIndex{
    for (NSInteger i = 0; i < self.childControllers.count; i++) {
        id obj = self.childControllers[i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController *)obj;
            [controller willMoveToParentViewController:self];
            if (i == currentIndex) {
                [self addChildViewController:controller];
            }else{
                [controller removeFromParentViewController];
            }
            [controller didMoveToParentViewController:self];
        }
    }
}

#pragma mark - YSLScrollMenuView Delegate
- (void)scrollMenuViewSelectedIndex:(NSInteger)index{
    [self setSelectedIndex:index animated:YES];
}

#pragma mark - ScrollerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat oldPointX = self.currentIndex * scrollView.frame.size.width;
    CGFloat ratio = (scrollView.contentOffset.x - oldPointX) / scrollView.frame.size.width;
    
    BOOL isToNextItem = (_contentScrollView.contentOffset.x >oldPointX);
    NSInteger targetIndex = isToNextItem? self.currentIndex+1 : self.currentIndex - 1;
    
    CGFloat nextItemOffsetX = 1.0f;
    CGFloat currentItemOffsetX = 1.f;
    
    nextItemOffsetX = (_menuView.scrollView.contentSize.width - _menuView.scrollView.frame.size.width) * targetIndex / (_menuView.itemViewArray.count - 1);
    currentItemOffsetX = (_menuView.scrollView.contentSize.width - _menuView.scrollView.frame.size.width) * self.currentIndex / (_menuView.itemViewArray.count - 1);
    
    if (targetIndex >= 0 && targetIndex < self.childControllers.count) {
        //MenuView Move
        CGFloat indicatorUpdateRatio = ratio;
        if (isToNextItem) {
            CGPoint offset = _menuView.scrollView.contentOffset;
            offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio +currentItemOffsetX;
            [_menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio *1;
            [_menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:self.currentIndex];
        }else{
            CGPoint offset = _menuView.scrollView.contentOffset;
            offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio;
            
            indicatorUpdateRatio = ratio * -1;
            [_menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:targetIndex];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentIndex = scrollView.contentOffset.x / _contentScrollView.frame.size.width;
    
    if (currentIndex == self.currentIndex) { return; }
    self.currentIndex = currentIndex;
    
    // item color
    [_menuView setItemTextColor:self.menuItemTitleColor
           seletedItemTextColor:self.menuItemSelectedTitleColor
                   currentIndex:currentIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerViewItemIndex:currentController:)]) {
        [self.delegate containerViewItemIndex:self.currentIndex currentController:_childControllers[self.currentIndex]];
    }
    [self setChildControllersWithCurrentIndext:self.currentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

@end

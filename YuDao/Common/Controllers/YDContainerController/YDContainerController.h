//
//  ContainerController.h
//  YuDao
//
//  Created by 汪杰 on 16/9/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDScrollMenuView.h"

@protocol YDContainerControllerDelegate <NSObject>

- (void)containerViewItemIndex:(NSInteger )index currentController:(UIViewController *)controller;

@end

@interface YDContainerController : UIViewController

@property (nonatomic, weak) id<YDContainerControllerDelegate> delegate;

@property (nonatomic, strong) YDScrollMenuView *menuView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong, readonly) NSMutableArray *titles;

@property (nonatomic, strong, readonly) NSMutableArray *childControllers;

@property (nonatomic, assign) CGFloat topBarHeight;

//当前索引
@property (nonatomic, assign) NSInteger currentIndex;

#pragma mark - 滑动菜单栏
//高度
@property (nonatomic, assign) CGFloat scrollMenuViewHeight;

//字体
@property (nonatomic, strong) UIFont  *menuItemFont;

//标题颜色
@property (nonatomic, strong) UIColor *menuItemTitleColor;

//选中标题颜色
@property (nonatomic, strong) UIColor *menuItemSelectedTitleColor;

//背景色
@property (nonatomic, strong) UIColor *menuBackgroudColor;

//提示条颜色
@property (nonatomic, strong) UIColor *menuIndicatorColor;

/**
 设置容器当前显示的控制器
 */
- (void)setSelectedIndex:(NSInteger )index animated:(BOOL )animated;

/**
 初始化
 */
- (id)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
         parentController:(UIViewController *)parentController;

@end

//
//  YDNavigationBar.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kShowNavigationBarHeight 200.0

@interface YDNavigationBar : UIView

/**
 状态栏（假）
 */
@property (nonatomic, strong) UIView *statusBar;
/**
 导航栏（假）
 */
@property (nonatomic, strong) UIView *navigationBar;

/**
 statusBar+navigationBar的背景色
 */
@property (nonatomic, strong) UIColor *status_navigationBackgroundColor;

/**
 导航栏标题
 */
@property (nonatomic, strong) NSString *title;

/**
 导航栏标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 左边按钮
 */
@property (nonatomic, strong) UIButton *leftBarItem;

/**
 右边按钮
 */
@property (nonatomic, strong) UIButton *rightBarItem;


//滑动显示或隐藏导航栏，将此方法放入scorllerViewDidScroll中
- (void)changeViewAlphaWithOffset:(CGFloat )offset;

@end

//
//  UINavigationController+StackManager.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/4/25.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (StackManager)
/**
 *  @brief  寻找Navigation中的某个viewcontroler对象
 *
 *  @param className viewcontroler名称
 *
 *  @return viewcontroler对象
 */
- (id)findViewController:(NSString*)className;

/**
 查询controller的前previousLevel的控制器

 @param controller 要查询的控制器
 @param previousLevel 相对controller的前几个，0则为controller
 @return 查询到的界面，没查到为nil
 */
- (id)findViewController:(UIViewController *)controller previousLevel:(NSUInteger)previousLevel;

/**
 *  @brief  判断是否只有一个RootViewController
 *
 *  @return 是否只有一个RootViewController
 */
- (BOOL)isOnlyContainRootViewController;
/**
 *  @brief  RootViewController
 *
 *  @return RootViewController
 */
- (UIViewController *)rootViewController;
/**
 *  @brief  返回指定的viewcontroler
 *
 *  @param className 指定viewcontroler类名
 *  @param animated  是否动画
 *
 *  @return pop之后的viewcontrolers
 */
- (NSArray *)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
/**
 *  @brief  pop n层
 *
 *  @param level  n层
 *  @param animated  是否动画
 *
 *  @return pop之后的viewcontrolers
 */
- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;

/**
 当前控制器在那一层

 @param className 控制器类名
 @return 层数
 */
- (NSInteger)currentLevelWithClassName:(NSString *)className;

/**
 从层数查询控制器

 @param level 层数
 @return 控制器
 */
- (id)findViewControllerWithLevel:(NSInteger)level;


@end

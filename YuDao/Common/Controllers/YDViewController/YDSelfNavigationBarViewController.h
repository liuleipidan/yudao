//
//  YDSelfNavigationBarViewController.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDNavigationBar.h"

/**
 自带自定义NavigationBar的viewController
 */
@interface YDSelfNavigationBarViewController : UIViewController
{
    YDNavigationBar *_navigationBar;
}
@property (nonatomic, strong) YDNavigationBar *navigationBar;

//状态栏样式，默认UIStatusBarStyleDefault
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

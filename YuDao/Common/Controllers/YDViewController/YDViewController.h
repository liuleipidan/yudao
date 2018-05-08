//
//  YDViewController.h
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDViewController : UIViewController

@property (nonatomic, strong) NSString *analyzeTitle;

//获取当前视图控制器 ClassString
+ (UIViewController *)getCurrentViewController;

@end

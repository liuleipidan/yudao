//
//  YDBiBiPopViewController.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDBiBiPopViewController : UIViewController

@property (nonatomic,copy) void (^selectedItemBlock) (NSInteger index);

- (instancetype)initWithBackgroundImage:(UIImage *)image;

@end

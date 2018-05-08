//
//  YDProgressTool.h
//  YuDao
//
//  Created by 汪杰 on 17/3/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDProgressTool : NSObject

+ (void)showInNavigationRightItem:(UINavigationBar *)navBar;

+ (void)showInView:(UIView *)view withstyle:(UIActivityIndicatorViewStyle )style;

+ (void)hide;

@end

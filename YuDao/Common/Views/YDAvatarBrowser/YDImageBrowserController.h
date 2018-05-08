//
//  YDImageBrowserController.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDImageBrowserController;
@protocol YDImageBrowserControllerDelegate <NSObject>

@optional

- (UIImageView *)imageBrowserControllerOriginalImageV:(YDImageBrowserController *)controller;

- (void)imageBrowserController:(YDImageBrowserController *)controller imageIsChanged:(BOOL)isChanged;

@end

@interface YDImageBrowserController : UIViewController

@property (nonatomic, weak  ) id<YDImageBrowserControllerDelegate> delegate;

@end

//
//  YDSearchController.h
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

//默认搜索框文字
static NSString *const kSBDefaultPlaceholder = @"搜索";

@class YDSearchController;
@protocol YDSearchControllerCustomDelegagte <NSObject>

@optional
- (void)searchControllerWillPresent:(YDSearchController *)controller;

- (void)searchControllerDidPresent:(YDSearchController *)controller;

- (void)searchControllerWillDismiss:(YDSearchController *)controller;

- (void)searchControllerDidDismiss:(YDSearchController *)controller;

@end

@interface YDSearchController : UISearchController

@property (nonatomic, weak  ) id<YDSearchControllerCustomDelegagte> customDelegate;

//重写初始化方法
- (id)initWithSearchResultsController:(UIViewController *)searchResultsController;

@end

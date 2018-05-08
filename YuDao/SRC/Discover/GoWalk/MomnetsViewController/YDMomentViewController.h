//
//  YDMomentViewController.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDMomentProxy.h"
#import "UITableView+VideoPlay.h"

@class YDMomentViewController;
@protocol YDMomentViewControllerDelegate <NSObject>

- (void)momentViewController:(YDMomentViewController *)controller didScrollOffsetY:(CGFloat )offsetY;

@end

@interface YDMomentViewController : YDViewController

@property (nonatomic, weak  ) id<YDMomentViewControllerDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign, readonly) YDGowalkViewControllerType vcType;

@property (nonatomic, strong) YDMomentProxy *momentProxy;


- (instancetype)initWithType:(YDGowalkViewControllerType )type;

/**
 刷新前十条动态
 */
- (void)mc_headerAction;

@end

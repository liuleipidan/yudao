//
//  YDHPDynamicController.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"

@class YDHPDynamicController;
@protocol YDHPDynamicControllerDelegate <NSObject>

//排行榜数据加载完成
- (void)HPDynamicControllerDataDidLoad:(YDHPDynamicController *)controller viewHeight:(CGFloat)viewHeight;

@end

@interface YDHPDynamicController : YDViewController
{
    YDTableView *_tableView;
}

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, weak  ) id<YDHPDynamicControllerDelegate> delegate;

/**
 请求首页动态数据
 */
- (void)requestHomePageDynamics;

@end

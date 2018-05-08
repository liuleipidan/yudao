//
//  YDHPMessageController.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTableViewController.h"
#import "YDHPMessageWeatherCell.h"
#import "YDHPMessageWeeklyReportCell.h"
#import "YDHPMessageActivityCell.h"
#import "YDHPMessageCouponCell.h"
#import "YDHPMessageViewModel.h"

#define kHPMessageTableViewRowHeight 186.0f

@class YDHPMessageController;
@protocol YDHPMessageControllerDelegate <NSObject>

- (void)HPMessageController:(YDHPMessageController *)controller dataSourceDidChanged:(CGFloat )contentHeight;

@end

@interface YDHPMessageController : YDTableViewController

@property (nonatomic,weak) id<YDHPMessageControllerDelegate> messageDelegate;

@property (nonatomic, strong) NSMutableArray<YDHPMessageModel *> *data;

@property (nonatomic, strong) YDHPMessageViewModel *viewModel;

@end

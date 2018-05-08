//
//  YDTestsController.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDCarDetailModel+Test.h"
#import "YDTestTopView.h"

#import "YDTestCuringCell.h"
#import "YDTestOilCell.h"
#import "YDTestOtherDataCell.h"
#import "YDTestIllegalCell.h"
#import "YDTestCodeCell.h"
#import "YDTestAQICell.h"
#import "YDTestTitleView.h"

@interface YDTestsController : YDViewController

@property (nonatomic, strong) YDTableView *tableView;

@property (nonatomic, strong) YDCarDetailModel *car;

@property (nonatomic, strong) YDTestTopView *topView;

@property (nonatomic, strong) YDTestTitleView *titleView;

@end

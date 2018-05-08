//
//  YDTrafficInfoController.h
//  YuDao
//
//  Created by 汪杰 on 16/12/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDCarsLocationView.h"
#import "YDPopTableView.h"
#import "YDCarInfoView.h"
#import "YDTestsController.h"
#import "YDTrafficInfoManager.h"
#import "YDBluetoothManager.h"

@interface YDTrafficInfoController : YDViewController
{
    YDTrafficInfoManager *_infoManager;
}

@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic, strong) YDPopTableView    *tableView;

@property (nonatomic, strong) YDCarInfoView     *carInfoView;

@property (nonatomic, strong) YDCarsLocationView *carLocView;


/**
 行车信息管理类
 */
@property (nonatomic, strong) YDTrafficInfoManager *infoManager;

/**
 请求行车信息
 */
- (void)requestTrafficInfo;

@end

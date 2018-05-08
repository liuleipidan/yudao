//
//  YDUserDynamicViewController.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/11.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDUserDynamicProxy.h"
#import "YDDynamicsTableView.h"

@interface YDUserDynamicViewController : YDViewController

@property (nonatomic, strong) YDDynamicsTableView *tableView;

@property (nonatomic, strong) YDUserDynamicProxy *dynamicProxy;

@end

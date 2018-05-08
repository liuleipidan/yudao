//
//  YDDynamicLabelController.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDContactHeaderView.h"
#import "YDLimitTextField.h"
#import "YDLabelViewModel.h"

@interface YDDynamicLabelController : YDViewController

@property (nonatomic,copy) void (^DLCDidSelectedBlock )(NSString *label);

@property (nonatomic, strong) YDLabelViewModel *viewModel;

@property (nonatomic, strong) YDLimitTextField *textField;

@property (nonatomic, strong) YDTableView *tableView;

@end

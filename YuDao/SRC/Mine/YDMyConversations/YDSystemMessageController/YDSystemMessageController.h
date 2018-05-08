//
//  YDSystemMessageController.h
//  YuDao
//
//  Created by 汪杰 on 17/2/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTableViewController.h"
#import "YDSystemMessageHelper.h"

@interface YDSystemMessageController : YDTableViewController

@property (nonatomic,strong) NSMutableArray<YDSystemMessage *> *data;

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;

@end

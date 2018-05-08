//
//  YDRankingListController.h
//  YuDao
//
//  Created by 汪杰 on 16/12/13.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDTaskModel.h"
#import "YDTaskView.h"

/**
 任务控制器
 */
@interface YDTaskController : YDViewController
{
    YDTaskView *_taskView;
}

@property (nonatomic, strong) YDTaskView *taskView;

/**
 当前的一条任务
 */
@property (nonatomic, strong) YDTaskModel *task;

/**
 请求用户任务
 */
- (void)requestUserTask;

@end

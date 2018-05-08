//
//  YDTaskView.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/2.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDTaskModel.h"

@protocol YDTaskViewDelegate <NSObject>

/**
 点击整个任务视图

 @param model 当前任务
 */
- (void)taskViewBeClicked:(YDTaskModel *)model;

/**
 点击重新加载按钮
 */
- (void)taskViewClickReloadButton:(UIButton *)sender;

@end

/**
 任务预览层
 */
@interface YDTaskView : UIView

@property (nonatomic,weak) id<YDTaskViewDelegate> delegate;

@property (nonatomic, strong) YDTaskModel *model;

/**
 任务数据加载鼠标
 */
- (void)taskDataLoadFailure;

/**
 显示加载视图
 */
- (void)showLoadView;

/**
 关闭加载视图
 */
- (void)hideLoadView;

@end

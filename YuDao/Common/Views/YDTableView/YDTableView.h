//
//  YDTableView.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/11.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 通用tableView
 默认属性：
 backgroundColor = whiteColor;
 separatorStyle = UITableViewCellSeparatorStyleNone
 contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever
 estimatedRowHeight = 0.0f
 estimatedSectionHeaderHeight = 0.0f
 estimatedSectionFooterHeight = 0.0f
 */
@interface YDTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                   dataSource:(id<UITableViewDataSource>)dataSource
                     delegate:(id<UITableViewDelegate>)delegate;

@end

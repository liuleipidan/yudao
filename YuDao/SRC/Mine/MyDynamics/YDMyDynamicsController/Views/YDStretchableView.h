//
//  YDStretchableView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 宽高同时拉伸的头部视图
 */
@interface YDStretchableView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *contentView;

/**
 捆绑tableView和contentView

 @param tableView 要添加头部视图的表格
 @param contentView 头部视图里的内容
 */
- (void)stretchHeaderForTableView:(UITableView *)tableView contentView:(UIView *)contentView;

- (void)wj_scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)resizeView;

@end

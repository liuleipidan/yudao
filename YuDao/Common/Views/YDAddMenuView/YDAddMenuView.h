//
//  TLAddMenuView.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/11.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDPopDownCell.h"

@class YDAddMenuView;
@protocol YDAddMenuViewDelegate <NSObject>

- (void)addMenuView:(YDAddMenuView *)addMenuView didSelectedItem:(YDAddMenuItem *)item;

@end

@interface YDAddMenuView : UIView

@property (nonatomic, assign) id<YDAddMenuViewDelegate>delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

/**
 *  显示AddMenu
 *
 *  @param view 父View
 */
- (void)showInView:(UIView *)view;

/**
 *  是否正在显示
 */
- (BOOL)isShow;

/**
 *  隐藏
 */
- (void)dismiss;

@end

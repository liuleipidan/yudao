//
//  UITableView+YDChat.h
//  YuDao
//
//  Created by 汪杰 on 16/10/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YDChat)

- (void)scrollToBottomWithAnimation:(BOOL)animation;

- (void)scrollToBottonRow:(NSUInteger )row animation:(BOOL)animation;

- (void)yd_scrollToFoot:(BOOL)animated;

- (void)yd_adaptToIOS11;

@end

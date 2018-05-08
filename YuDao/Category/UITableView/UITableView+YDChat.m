//
//  UITableView+YDChat.m
//  YuDao
//
//  Created by 汪杰 on 16/10/21.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "UITableView+YDChat.h"

@implementation UITableView (YDChat)

- (void)scrollToBottomWithAnimation:(BOOL)animation
{
    CGFloat offsetY = self.contentSize.height > self.height ? self.contentSize.height - self.height : 0;
    [self setContentOffset:CGPointMake(0, offsetY) animated:animation];
}

- (void)scrollToBottonRow:(NSUInteger )row animation:(BOOL)animation{
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animation];
}

- (void)yd_scrollToFoot:(BOOL)animated
{
    NSInteger s = [self numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
    
}


- (void)yd_adaptToIOS11{
    //iOS11
    [self yd_setContentInsetAdjustmentBehavior:2];
    [self setEstimatedRowHeight:0.0f];
    [self setEstimatedSectionHeaderHeight:0.0f];
    [self setEstimatedSectionFooterHeight:0.0f];
}

@end

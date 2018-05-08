//
//  UIView+Extensions.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)

- (void)removeAllSubViews;

/**
 添加子视图数组

 @param subviews 子视图数组
 */
- (void)yd_addSubviews:(NSArray *)subviews;

@end

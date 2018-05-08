//
//  UIScrollView+YuDao.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YuDao)

/**
 修改UIScrollView的AdjustmentBehavior

 @param behavior 枚举
 UIScrollViewContentInsetAdjustmentAutomatic = 0
 UIScrollViewContentInsetAdjustmentScrollableAxes
 UIScrollViewContentInsetAdjustmentNever
 UIScrollViewContentInsetAdjustmentAlways
 */
- (void)yd_setContentInsetAdjustmentBehavior:(NSInteger)behavior;

@end

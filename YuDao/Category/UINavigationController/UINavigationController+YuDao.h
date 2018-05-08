//
//  UINavigationController+YuDao.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (YuDao)


/**
 在有ScrollView时加入侧滑返回,支持iOS7.0及以上
 使用:
 [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.screenEdgePanGestureRecognizer];
 */
@property (nonatomic, readonly) UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer;


/**
 是否隐藏导航栏底部黑线

 @param hidden YES or NO
 */
- (void)yd_hiddenBottomImageView:(BOOL )hidden;

@end

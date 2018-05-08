//
//  UINavigationController+YuDao.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "UINavigationController+YuDao.h"

@implementation UINavigationController (YuDao)

@dynamic screenEdgePanGestureRecognizer;

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    
    return screenEdgePanGestureRecognizer;
}

- (void)yd_hiddenBottomImageView:(BOOL )hidden{
    UIImageView *imageV = [self findHairlineImageViewUnder:self.navigationBar];
    imageV.hidden = hidden;
}

#pragma mark - Private Methods
//查到到导航栏底部黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end

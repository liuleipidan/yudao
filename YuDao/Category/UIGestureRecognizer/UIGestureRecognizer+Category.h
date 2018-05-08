//
//  UIGestureRecognizer+Category.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YDPanGestureRecognizerMoveDirection) {
    YDPanGestureRecognizerMoveDirectionNone = 0,
    YDPanGestureRecognizerMoveDirectionUp,
    YDPanGestureRecognizerMoveDirectionDown,
    YDPanGestureRecognizerMoveDirectionLeft,
    YDPanGestureRecognizerMoveDirectionRight,
};

@interface UIGestureRecognizer (Category)

//计算Pan手势的滑动方向
- (YDPanGestureRecognizerMoveDirection)yd_determineCameraDirectionIfNeeded:(CGPoint)translation;

@end

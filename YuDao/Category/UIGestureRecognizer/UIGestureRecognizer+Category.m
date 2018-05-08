//
//  UIGestureRecognizer+Category.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "UIGestureRecognizer+Category.h"

CGFloat const gestureMinimumTranslation = 20.0;

@implementation UIGestureRecognizer (Category)

- (YDPanGestureRecognizerMoveDirection)yd_determineCameraDirectionIfNeeded:(CGPoint)translation{
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return YDPanGestureRecognizerMoveDirectionNone;
    if (absX > absY ) {
        
        if (translation.x<0) {
            return YDPanGestureRecognizerMoveDirectionLeft;
        }
        else{
            return YDPanGestureRecognizerMoveDirectionRight;
        }
        
    } else if (absY > absX) {
        if (translation.y<0) {
            return YDPanGestureRecognizerMoveDirectionUp;
        }
        else{
            return YDPanGestureRecognizerMoveDirectionDown;
        }
    }
    return YDPanGestureRecognizerMoveDirectionNone;
}

@end

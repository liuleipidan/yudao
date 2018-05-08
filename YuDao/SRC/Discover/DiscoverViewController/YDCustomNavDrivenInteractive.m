//
//  YDCustomNavDrivenInteractive.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCustomNavDrivenInteractive.h"

@interface YDCustomNavDrivenInteractive()

@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;

@end

@implementation YDCustomNavDrivenInteractive

#pragma mark - UIViewControllerInteractiveTransitioning
- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    [super startInteractiveTransition:transitionContext];
}

- (id)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer{
    if (self = [super init]) {
        
    }
    return self;
}



@end

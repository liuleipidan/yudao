//
//  YDSLBInteractiveTransition.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSLBInteractiveTransition : NSObject<UIViewControllerTransitioningDelegate>

- (void)setTransitionImgV:(UIImageView *)transitoinImgV;

- (void)setTransitionBeforeImgFrame:(CGRect)frame;

- (void)setTransitionAfterImgFrame:(CGRect)frame;

@property (nonatomic, assign) CGRect beforeImgFrame;

@property (nonatomic, assign) CGRect currentImgVFrame;

@property (nonatomic, strong) UIImageView *currentImgV;

@property (nonatomic, strong) UIPanGestureRecognizer *gestrueRecognizer;

@end

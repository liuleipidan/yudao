//
//  YDSLBPercentDrivenInteractive.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDSLBPercentDrivenInteractive : UIPercentDrivenInteractiveTransition

- (id)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer;

@property (nonatomic, assign) CGRect beforeImgVFrame;

@property (nonatomic, assign) CGRect currentImgVFrame;

@property (nonatomic, strong) UIImageView *currentImgV;

@end

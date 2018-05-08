//
//  YDPercentLabel.h
//  YuDao
//
//  Created by 汪杰 on 2017/4/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YDPercentLayer;
@protocol KNPercentDelegate;

/**
 跑分label
 */
@interface YDPercentLabel : NSObject
@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;

- (instancetype)initWithObject:(UIView *)object key:(NSString *)key from:(CGFloat)fromValue to:(CGFloat)toValue duration:(NSTimeInterval)duration;

- (void)start;

//隐藏label
- (void)setHidden:(BOOL)hidden;

@end

@interface YDPercentLayer : CALayer

@property (strong, nonatomic) id<KNPercentDelegate> tweenDelegate;
@property (nonatomic) CGFloat fromValue;
@property (nonatomic) CGFloat toValue;
@property (nonatomic) NSTimeInterval tweenDuration;

- (instancetype)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration;

- (void)startAnimation;

@end

@protocol KNPercentDelegate <NSObject>

- (void)layer:(YDPercentLayer *)layer didSetAnimationPropertyTo:(CGFloat)toValue;
- (void)layerDidStopAnimation;

@end

//
//  YDPercentLabel.h
//  YuDao
//
//  Created by 汪杰 on 2017/4/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPercentLabel.h"

@interface YDPercentLabel() <KNPercentDelegate,CAAnimationDelegate>

@property (strong, nonatomic) YDPercentLayer *layer;
@property (strong, nonatomic) UIView *object;
@property (strong, nonatomic) NSString *key;

@end

@implementation YDPercentLabel

- (instancetype)initWithObject:(UIView *)object key:(NSString *)key from:(CGFloat)fromValue to:(CGFloat)toValue duration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        self.object = object;
        self.key = key;
        self.layer = [[YDPercentLayer alloc] init];
        self.layer.fromValue = fromValue;
        self.layer.toValue = toValue;
        self.layer.tweenDuration = duration;
        self.layer.tweenDelegate = self;
        [self.object.layer addSublayer:self.layer];
    }
    return self;
}
- (void)setHidden:(BOOL)hidden{
    self.object.hidden = hidden;
}
- (void)start {
    [self.layer startAnimation];
}

- (void)layer:(YDPercentLayer *)layer didSetAnimationPropertyTo:(CGFloat)toValue {
    int percent = (int)toValue;
    
    NSString *text = [NSString stringWithFormat:@"%2d", percent];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:68]} range:NSMakeRange(0, text.length)];
    
    [self.object setValue:attributeString forKey:self.key];
    
}

- (void)layerDidStopAnimation {
    int percent = (int)self.layer.toValue;
    NSString *text = [NSString stringWithFormat:@"%2d", percent];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:68]} range:NSMakeRange(0, text.length)];
    [self.object setValue:attributeString forKey:self.key];
    [self.layer removeFromSuperlayer];
}
@end


//=============================================================//
@interface YDPercentLayer()

@property (nonatomic) CGFloat animatableProperty;
@property (nonatomic) CGFloat delay;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;

@end

@implementation YDPercentLayer

@dynamic animatableProperty;
@dynamic color;

- (instancetype)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration {
    self = [super init];
    if (self) {
        self.fromValue = fromValue;
        self.toValue = toValue;
        self.duration = duration;
        self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {

    if ([key isEqualToString:@"animatableProperty"] || [key isEqualToString:@"color"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if (![event isEqualToString:@"animatableProperty"] && ![event isEqualToString:@"color"]) {
        return [super animationForKey:event];
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
    animation.timingFunction = self.timingFunction;
    animation.fromValue = [NSNumber numberWithFloat:self.fromValue];
    animation.toValue = [NSNumber numberWithFloat:self.toValue];
    animation.duration = self.tweenDuration;
    animation.beginTime = CACurrentMediaTime() + self.delay;
    animation.delegate = (id)self;
    
    return animation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.tweenDelegate layerDidStopAnimation];
}

- (void)display {
    if (self.presentationLayer != nil) {
        YDPercentLayer *tweenLayer = (YDPercentLayer *)self.presentationLayer;
        [self.tweenDelegate layer:self didSetAnimationPropertyTo:tweenLayer.animatableProperty];
    }
}

- (void)startAnimation {
    self.animatableProperty = self.toValue;
}

@end

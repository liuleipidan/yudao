//
//  YDTestCircleAnimationView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/22.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestCircleAnimationView.h"

#define kDuration 1.0

#define kDefaultLineWidth 10

@interface YDTestCircleAnimationView()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) CAShapeLayer *outLineLayer;

@property (nonatomic, strong) CAShapeLayer *inLineLayer;

@end

@implementation YDTestCircleAnimationView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self ca_initSubviews];
        
        //Init Default Variables
        self.backgroundLineWidth = kDefaultLineWidth;
        self.progressLineWidth = kDefaultLineWidth;
        self.percentage = 0;
        self.offset = 0;
        self.step = 0.1;
    }
    return self;
}

#pragma mark - Public Method
- (void)setProgress:(CGFloat)percentage animated:(BOOL)animated
{
    if (percentage <= 0) {
        return;
    }
    self.percentage = percentage;
    _progressLayer.strokeEnd = _percentage;
    _outLineLayer.strokeEnd = _percentage;
    _inLineLayer.strokeEnd = 1.0 - _percentage;
    
    if (animated) {
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation1.fromValue = [NSNumber numberWithFloat:0.0];
        animation1.toValue = [NSNumber numberWithFloat:_percentage];
        animation1.duration = kDuration;
        
        [_progressLayer addAnimation:animation1 forKey:@"strokeEndAnimation"];
        [_outLineLayer addAnimation:animation1 forKey:@"strokeEndAnimation"];
        
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation2.fromValue = [NSNumber numberWithFloat:1.0];
        animation2.toValue = [NSNumber numberWithFloat:1.0 - _percentage];
        animation2.duration = kDuration;
        [_inLineLayer addAnimation:animation2 forKey:@"strokeEndAnimation"];
    }
    else{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction commit];
    }
}

#pragma mark - Private Methods
- (void)ca_initSubviews{
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.frame = self.bounds;
    _backgroundLayer.fillColor = nil;
    _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = nil;
    _progressLayer.strokeColor = [UIColor redColor].CGColor;
    _progressLayer.lineCap = @"round";
    
    _outLineLayer = [CAShapeLayer layer];
    _outLineLayer.frame = self.bounds;
    _outLineLayer.fillColor = nil;
    _outLineLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    _outLineLayer.lineWidth = 2;
    _outLineLayer.lineCap = @"round";
    
    _inLineLayer = [CAShapeLayer layer];
    _inLineLayer.frame = self.bounds;
    _inLineLayer.fillColor = nil;
    _inLineLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    _inLineLayer.lineWidth = 2;
    _inLineLayer.lineCap = @"round";
    
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_progressLayer];
    
    [self.layer addSublayer:_outLineLayer];
    [self.layer addSublayer:_inLineLayer];
    
}

#pragma mark - draw circleLine
- (void)setBackgroundCircleLine
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y)
                                          radius:(self.frame.size.width -     _backgroundLineWidth)/2 - 11
                                      startAngle:0
                                        endAngle:M_PI*2
                                       clockwise:YES];
    
    _backgroundLayer.path = path1.CGPath;
}

- (void)setProgressCircleLine
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    path1 = [UIBezierPath     bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y)
                                              radius:(self.frame.size.width - _progressLineWidth)/2 - _offset
                                          startAngle:-M_PI_2
                                            endAngle:-M_PI_2 + M_PI *2
                                           clockwise:YES];
    //终点
    path1.lineCapStyle = kCGLineCapRound;
    //连接点
    path1.lineJoinStyle = kCGLineJoinRound;
    _outLineLayer.path = path1.CGPath;
    
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2 = [UIBezierPath     bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y)
                                              radius:(self.frame.size.width - _progressLineWidth)/2 - 11
                                          startAngle:-M_PI_2
                                            endAngle:-M_PI_2 + M_PI *2
                                           clockwise:YES];
    path2.lineCapStyle = kCGLineCapRound;
    path2.lineJoinStyle = kCGLineJoinRound;
    _progressLayer.path = path2.CGPath;
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    path3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y)
                                          radius:(self.frame.size.width -     _backgroundLineWidth)/2 - 20
                                      startAngle:-M_PI_2
                                        endAngle:-M_PI_2 - M_PI *2
                                       clockwise:NO];
    _inLineLayer.path = path3.CGPath;
}

#pragma mark - Setters
- (void)setBackgroundLineWidth:(CGFloat)backgroundLineWidth
{
    _backgroundLineWidth = backgroundLineWidth;
    _backgroundLayer.lineWidth = _backgroundLineWidth;
    [self setBackgroundCircleLine];
}

- (void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    _progressLineWidth = progressLineWidth;
    _progressLayer.lineWidth = _progressLineWidth;
    [self setProgressCircleLine];
}

- (void)setPercentage:(CGFloat)percentage
{
    _percentage = percentage;
}

- (void)setBackgroundStrokeColor:(UIColor *)backgroundStrokeColor
{
    _backgroundStrokeColor = backgroundStrokeColor;
    _backgroundLayer.strokeColor =     _backgroundStrokeColor.CGColor;
}

- (void)setProgressStrokeColor:(UIColor *)progressStrokeColor
{
    _progressStrokeColor = progressStrokeColor;
    _progressLayer.strokeColor = _progressStrokeColor.CGColor;
}


@end

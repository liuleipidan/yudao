//
//  YDCameraProgressView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCameraProgressView.h"

#define kCameraProgressViewLineWidth 7.5f

@interface YDCameraProgressView()

/**
 *  进度值0-1.0之间
 */
@property (nonatomic,assign)CGFloat progressValue;

@property (nonatomic, strong) UIImageView *backgroundImageV;

@end

@implementation YDCameraProgressView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.width/2.0);  //设置圆心位置
    CGFloat radius = (self.frame.size.width-kCameraProgressViewLineWidth)/2.0;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progressValue;  //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, kCameraProgressViewLineWidth); //设置线条宽度
    [[UIColor greenColor] setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
}

- (void)setTimeMax:(NSInteger)timeMax {
    self.hidden = NO;
    
    _timeMax = timeMax;
    self.currentTime = 0;
    self.progressValue = 0;
    [self setNeedsDisplay];
    
    [self performSelector:@selector(startProgress) withObject:nil afterDelay:0.1];
}

- (void)clearProgress {
    
    self.hidden = YES;
}

- (void)startProgress {
    _currentTime += 0.1;
    if (_timeMax > _currentTime) {
        _progressValue = _currentTime/_timeMax;
        [self setNeedsDisplay];
        [self performSelector:@selector(startProgress) withObject:nil afterDelay:0.1];
    }
    
    if (_timeMax <= _currentTime) {
        [self clearProgress];
        if (self.timeOverBlock) {
            self.timeOverBlock();
        }
    }
}

@end

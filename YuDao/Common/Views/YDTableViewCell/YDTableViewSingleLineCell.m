//
//  YDTableViewSingleLineCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTableViewSingleLineCell.h"

@implementation YDTableViewSingleLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _separatorLineHeight = 1.0f;
        _leftSeparatorSpace = 10.0f;
        _rightSeparatorSpace = 10.0f;
        _topLineStyle = YDCellSingleLineStyleNone;
        _bottomLineStyle = YDCellSingleLineStyleDefault;
    }
    return self;
}

#pragma mark - Setters
- (void)setSeparatorLineHeight:(CGFloat)separatorLineHeight{
    _separatorLineHeight = separatorLineHeight;
    [self setNeedsDisplay];
}

- (void)setLeftSeparatorSpace:(CGFloat)leftSeparatorSpace{
    _leftSeparatorSpace = leftSeparatorSpace;
    [self setNeedsDisplay];
}

- (void)setRightSeparatorSpace:(CGFloat)rightSeparatorSpace{
    _rightSeparatorSpace = rightSeparatorSpace;
    [self setNeedsDisplay];
}

- (void)setTopLineStyle:(YDCellSingleLineStyle)topLineStyle{
    _topLineStyle = topLineStyle;
    [self setNeedsDisplay];
}

- (void)setBottomLineStyle:(YDCellSingleLineStyle)bottomLineStyle{
    _bottomLineStyle = bottomLineStyle;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.separatorLineHeight == 0 ? : 1);
    CGContextSetStrokeColorWithColor(context, self.lineColor ? self.lineColor.CGColor : [UIColor grayCellLineColor].CGColor);
    
    if (self.topLineStyle != YDCellSingleLineStyleNone) {
        CGContextBeginPath(context);
        CGFloat startX = (self.topLineStyle == YDCellSingleLineStyleFill ? 0 : self.leftSeparatorSpace);
        CGFloat endX = self.width - self.rightSeparatorSpace;
        CGFloat y = 0;
        CGContextMoveToPoint(context, startX, y);
        CGContextAddLineToPoint(context, endX, y);
        CGContextStrokePath(context);
    }
    
    if (self.bottomLineStyle != YDCellSingleLineStyleNone) {
        CGContextBeginPath(context);
        CGFloat startX = (self.bottomLineStyle == YDCellSingleLineStyleFill ? 0 : self.leftSeparatorSpace);
        CGFloat endX = self.width - self.rightSeparatorSpace;
        CGFloat y = self.height;
        CGContextMoveToPoint(context, startX, y);
        CGContextAddLineToPoint(context, endX, y);
        CGContextStrokePath(context);
    }
}

@end

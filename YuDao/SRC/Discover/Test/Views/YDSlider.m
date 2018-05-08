//
//  YDSlider.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/22.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSlider.h"

@implementation YDSlider

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
    
    return [super minimumValueImageRectForBounds:bounds];
}

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
    
    return [super maximumValueImageRectForBounds:bounds];
}

- (CGRect)trackRectForBounds:(CGRect)bounds{
    
    return CGRectMake(0, 0, bounds.size.width, 10);
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    
    return [super thumbRectForBounds:bounds trackRect:rect value:value];
}

@end

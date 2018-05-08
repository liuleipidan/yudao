//
//  YDNavigationBar.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDNavigationBar.h"

@implementation YDNavigationBar
{
    UILabel *_navigationLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupNavigationBar];
    }
    return self;
}

- (void)setupNavigationBar{
    _statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUSBAR_HEIGHT)];
    _statusBar.backgroundColor = [UIColor baseColor];
    [self addSubview:_statusBar];
    
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    _navigationBar.backgroundColor = [UIColor baseColor];
    [self addSubview:_navigationBar];
    
    _navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, STATUSBAR_HEIGHT, SCREEN_WIDTH - 200, NAVBAR_HEIGHT)];
    _navigationLabel.textAlignment = NSTextAlignmentCenter;
    _navigationLabel.font = [UIFont pingFangSC_MediumFont:18];
    _navigationLabel.textColor = [UIColor whiteColor];
    _navigationLabel.backgroundColor = [UIColor clearColor];
    _navigationLabel.text = _title;
    [self addSubview:_navigationLabel];
}


#pragma mark - Setters
- (void)setStatus_navigationBackgroundColor:(UIColor *)status_navigationBackgroundColor{
    _status_navigationBackgroundColor = status_navigationBackgroundColor;
    _statusBar.backgroundColor = status_navigationBackgroundColor;
    _navigationBar.backgroundColor = status_navigationBackgroundColor;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    _navigationLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    _navigationLabel.textColor = titleColor;
}

- (void)setLeftBarItem:(UIButton *)leftBarItem{
    _leftBarItem = leftBarItem;
    
    if (_leftBarItem) {
        _leftBarItem.frame = CGRectMake(0, STATUSBAR_HEIGHT, 40, 44);
        [self addSubview:_leftBarItem];
    }
}

- (void)setRightBarItem:(UIButton *)rightBarItem{
    _rightBarItem = rightBarItem;
    if (_rightBarItem) {
        _rightBarItem.frame = CGRectMake(SCREEN_WIDTH-40, STATUSBAR_HEIGHT, 40, 44);
        [self addSubview:_rightBarItem];
    }
}

- (void)changeViewAlphaWithOffset:(CGFloat )offset{
    float h = offset / kShowNavigationBarHeight;
    self.alpha = (h > 1) ? 1 : h;
    
}

@end

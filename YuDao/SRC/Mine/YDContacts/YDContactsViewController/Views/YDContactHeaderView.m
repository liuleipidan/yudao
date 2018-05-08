//
//  YDContactHeaderView.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/28.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDContactHeaderView.h"

@interface YDContactHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation YDContactHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor tableViewSectionHeaderViewBackgoundColor];
        [self setBackgroundView:_bgView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel setFrame:CGRectMake(10 + _offset_X, 0, self.width - 15, self.height)];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [_titleLabel setText:title];
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setOffset_X:(CGFloat)offset_X{
    _offset_X = offset_X;
    
    [self layoutIfNeeded];
}

- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    [_bgView setBackgroundColor:bgColor];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setTextColor:[UIColor blackTextColor]];
    }
    return _titleLabel;
}

@end

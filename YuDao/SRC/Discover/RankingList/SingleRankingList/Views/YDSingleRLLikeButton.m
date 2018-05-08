//
//  YDSinagleRLLikeButton.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSingleRLLikeButton.h"

@interface YDSingleRLLikeButton()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *iconImageView;


@end

@implementation YDSingleRLLikeButton

- (id)initWithTitle:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath{
    if (self = [super init]) {
        self.title = title;
        self.iconPath = iconPath;
        self.iconHLPath = iconHLPath;
        
        [self yd_addSubviews:@[self.textLabel,self.iconImageView]];
        [self lb_addMasonry];
    }
    return self;
}

#pragma mark - Private Methods
- (void)lb_addMasonry{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(21, 18));
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
}

#pragma mark - Setters
- (void)setTitle:(NSString *)title{
    _title = title;
    self.textLabel.text = title;
}

- (void)setIconPath:(NSString *)iconPath{
    _iconPath = iconPath;
    self.iconImageView.image = [UIImage imageNamed:iconPath];
}

- (void)setIconHLPath:(NSString *)iconHLPath{
    _iconHLPath = iconHLPath;
    self.iconImageView.highlightedImage = [UIImage imageNamed:iconHLPath];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self.textLabel setHighlighted:selected];
    [self.iconImageView setHighlighted:selected];
}

#pragma mark - Getters
- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [UILabel labelByTextColor:[UIColor baseColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
        _textLabel.highlightedTextColor = [UIColor orangeTextColor];
    }
    return _textLabel;
}

- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

@end

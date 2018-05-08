//
//  YDIntegralHeaderView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDIntegralHeaderView.h"

@interface YDIntegralHeaderView()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) UILabel *allScoreLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation YDIntegralHeaderView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self ih_initSubviews];
        [self ih_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setAllScore:(NSUInteger )allScore usefulScore:(NSUInteger)usefulScore{
    NSString *allScoreString = [NSString stringWithFormat:@"目前累计积分：%lu",allScore];
    _allScoreLabel.text = allScoreString;
    _scoreLabel.text = [NSString stringWithFormat:@"%lu",usefulScore];
}

#pragma mark - Private Methods
- (void)ih_initSubviews{
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor baseColor];
    
    _borderView = [UIView new];
    _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    _borderView.layer.borderWidth = 1.0f;
    _borderView.layer.cornerRadius = 8.0f;
    
    _scoreLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:40] textAlignment:NSTextAlignmentCenter];
    _scoreLabel.text = @"...";
    
    _titleLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_16] textAlignment:NSTextAlignmentCenter];
    _titleLabel.text = @"可用积分";
    
    _allScoreLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_14] textAlignment:NSTextAlignmentCenter];
    
    _allScoreLabel.text = @"目前累计积分：";
    
    _bottomLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:18]];
    _bottomLabel.text = @"积分明细";
    
    [self yd_addSubviews:@[_bgView,_borderView,_scoreLabel,_titleLabel,_allScoreLabel,_bottomLabel]];
}

- (void)ih_addMasonry{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(171);
    }];
    
    [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(30);
        make.size.mas_equalTo(CGSizeMake(220, 96));
    }];
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.borderView.mas_top).offset(10);
        make.left.equalTo(self.borderView.mas_left);
        make.right.equalTo(self.borderView.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.borderView.mas_bottom).offset(-10);
        make.left.equalTo(self.borderView.mas_left);
        make.right.equalTo(self.borderView.mas_right);
        make.height.mas_equalTo(22);
    }];
    
    [_allScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(150);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.bgView.mas_bottom).offset(15);
        make.height.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(100);
    }];
}

@end

//
//  YDCarIllegalityHeaderView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/18.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarIllegalityHeaderView.h"

@interface YDCarIllegalityHeaderView()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UILabel *plateNumerLabel;

@property (nonatomic, strong) UILabel *carSeriesLabel;

@property (nonatomic, strong) UILabel *finesLabel;

@property (nonatomic, strong) UILabel *finesNumLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UILabel *scoreNumLabel;

@end

@implementation YDCarIllegalityHeaderView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.layer.shadowColor = [UIColor shadowColor].CGColor;
        self.layer.shadowOpacity = 1;
        
        [self ci_initSubviews];
        [self ci_addMasonry];
        
    }
    return self;
}

- (void)setPlateNumbaer:(NSString *)plateNumber carSeries:(NSString *)carSeries{
    _plateNumerLabel.text = plateNumber;
    _carSeriesLabel.text = carSeries;
}

- (void)setFines:(NSString *)fines score:(NSString *)score{
    _finesNumLabel.text = fines;
    _scoreNumLabel.text = score;
}

- (void)ci_initSubviews{
    _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_illegal_bgIcon"]];
    
    _coverView = [UIView new];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    _plateNumerLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:24] textAlignment:NSTextAlignmentCenter];
    
    _carSeriesLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter];
    
    _finesLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_12]];
    _finesLabel.text = @"罚款";
    
    _finesNumLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont systemFontOfSize:20]];
    
    _scoreLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_12]];
    _scoreLabel.text = @"扣分";
    
    _scoreNumLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont systemFontOfSize:20]];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor blackTextColor];
    
    [self yd_addSubviews:@[_bgImageView,_coverView,_plateNumerLabel,_carSeriesLabel,_finesLabel,_finesNumLabel,_scoreLabel,_scoreNumLabel,_lineView]];
}

- (void)ci_addMasonry{
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(180);
    }];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(180);
    }];
    
    [_plateNumerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(72);
        make.height.mas_equalTo(33);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_carSeriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_plateNumerLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 20);
    }];
    
    UIView *placeholderView = [UIView new];
    [self addSubview:placeholderView];
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self);
        make.top.equalTo(_bgImageView.mas_bottom);
        make.width.mas_equalTo(0);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(placeholderView);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(1);
    }];
    
    [_finesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(60));
        make.centerY.equalTo(placeholderView);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(30);
    }];
    
    [_finesNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_finesLabel.mas_right).offset(15);
        make.centerY.equalTo(placeholderView);
        make.height.mas_equalTo(24);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineView.mas_right).offset(kWidth(60));
        make.centerY.equalTo(placeholderView);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(30);
    }];
    
    [_scoreNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scoreLabel.mas_right).offset(15);
        make.centerY.equalTo(placeholderView);
        make.height.mas_equalTo(24);
        make.width.mas_lessThanOrEqualTo(50);
    }];
}


@end

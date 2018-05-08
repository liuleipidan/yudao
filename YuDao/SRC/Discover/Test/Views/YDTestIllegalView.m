//
//  YDTestIllegalView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/22.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestIllegalView.h"

@interface YDTestIllegalView()

@property (nonatomic, strong) UIImageView *dateBgView;

@property (nonatomic, strong) UILabel *monthLabel;

@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation YDTestIllegalView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self ti_initSubviews];
        [self ti_addMasonry];
        
    }
    return self;
}

- (void)setModel:(YDIllegalModel *)model{
    _model = model;
    
    _monthLabel.text = model.month;
    _dayLabel.text = model.day;
    _contentLabel.text = model.content;
}

#pragma mark - Private Methods
- (void)ti_initSubviews{
    _dateBgView = [[UIImageView alloc] initWithImage:YDImage(@"test_illegal_dateBG")];
    
    _monthLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:10] textAlignment:NSTextAlignmentCenter];
    
    _dayLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16] textAlignment:NSTextAlignmentCenter];
    
    _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    
    [_dateBgView yd_addSubviews:@[_monthLabel,_dayLabel]];
    
    [self yd_addSubviews:@[_dateBgView,_contentLabel]];
}

- (void)ti_addMasonry{
    [_dateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(46);
    }];
    
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_dateBgView);
        make.height.mas_equalTo(14);
    }];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_dateBgView);
        make.top.equalTo(_monthLabel.mas_bottom);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dateBgView.mas_right).offset(10);
        make.right.equalTo(self);
        make.centerY.equalTo(_dateBgView);
        make.height.mas_equalTo(20);
    }];
}

@end

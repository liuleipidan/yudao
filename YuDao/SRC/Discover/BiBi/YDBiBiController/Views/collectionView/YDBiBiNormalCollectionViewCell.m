//
//  YDBiBiNormalCollectionViewCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiNormalCollectionViewCell.h"

@interface YDBiBiNormalCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UIButton *button;

@end

@implementation YDBiBiNormalCollectionViewCell

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)setModel:(YDPointAnnotation *)model{
    _model = model;
    _titleLabel.text = model.name;
    _subTitleLabel.text = model.address;
    _distanceLabel.text = model.distance;
}

- (void)initSubviews{
    self.layer.cornerRadius = 8.0;
    
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = YDBaseColor;
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.font = [UIFont systemFontOfSize:14];
    _subTitleLabel.textColor = YDColorString(@"#BEBEBE");
    
    _distanceLabel = [UILabel new];
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    _distanceLabel.font = [UIFont systemFontOfSize:12];
    _distanceLabel.textColor = YDColorString(@"#BEBEBE");
    
    NSArray *labels = @[_titleLabel,_subTitleLabel,_distanceLabel];
    [labels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20);
        make.width.equalTo(self.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(22);
    }];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.width.equalTo(_titleLabel.mas_width);
        make.height.mas_equalTo(20);
    }];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(_titleLabel).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = YDBaseColor;
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
}

- (void)buttonAction:(UIButton *)sender{
    YDLog(@"buttonAction");
}

@end

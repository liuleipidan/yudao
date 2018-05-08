//
//  YDCarPaopaoView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCarPaopaoView.h"

@interface YDCarPaopaoView()

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UIImageView *goIcon;

@property (nonatomic, strong) UILabel *goLabel;

@end

@implementation YDCarPaopaoView

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

- (void)initSubviews{
    self.layer.contents =(id)[UIImage imageNamed:@"discover_car_bgIcon"].CGImage;
    
    _leftLabel = [UILabel new];
    _leftLabel.font = [UIFont systemFontOfSize:14];
    _leftLabel.textColor = [UIColor orangeTextColor];
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    _leftLabel.text = @"666m";
    
    _goIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_car_go"]];
    _goIcon.contentMode = UIViewContentModeScaleAspectFit;
    _goIcon.userInteractionEnabled = YES;
    [_goIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGoAction:)]];
    
    _goLabel = [UILabel new];
    _goLabel.font = [UIFont systemFontOfSize:10];
    _goLabel.textColor = [UIColor orangeTextColor];
    _goLabel.textAlignment = NSTextAlignmentCenter;
    _goLabel.text = @"到这去";
    
    UIView *line = [UIView new];
    line.backgroundColor = YDColorString(@"#DFDFDF");
    
    NSArray *views = @[line,_leftLabel,_goLabel,_goIcon];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(34);
    }];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(9);
        make.right.equalTo(line.mas_left).offset(0);
        make.centerY.equalTo(self);
    }];
    
    [_goLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(line.mas_right).offset(0);
        make.bottom.equalTo(self).offset(-8);
        make.height.mas_equalTo(15);
    }];
    
    [_goIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_goLabel);
        make.top.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    
}

- (void)tapGoAction:(UIGestureRecognizer *)ges{
    if (_selectedGoBlock) {
        _selectedGoBlock();
    }
}


- (void)setDistance:(NSString *)distance{
    _distance = distance;
    _leftLabel.text = distance;
}

@end

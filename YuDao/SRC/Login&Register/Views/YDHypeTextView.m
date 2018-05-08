//
//  YDHypeTextView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHypeTextView.h"

@interface YDHypeTextView()

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UILabel *normalLabel;

@property (nonatomic, strong) UIButton *hypeTextBtn;

@end

@implementation YDHypeTextView

- (instancetype)init{
    if (self = [super init]) {
        _selected = YES;
        [self initSubviews];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfViewAction:)]];
        
    }
    return self;
}
//点击勾选或取消
- (void)tapSelfViewAction:(UIGestureRecognizer *)tap{
    _selected = !_selected;
    NSString *imageStr = _selected ? @"bindOBD_defaultCar_selected" : @"bindOBD_defaultCar_normal";
    _imgV.image = [UIImage imageNamed:imageStr];
    if (_checkStatusChangeBlock) {
        _checkStatusChangeBlock(_selected);
    }
}
//点击超链接按钮
- (void)hypeTextBtnAction:(UIButton *)btn{
    NSLog(@"hypeTextBtnAction");
    if (_tapHypeTextBlock) {
        _tapHypeTextBlock();
    }
}

- (void)initSubviews{
    _imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bindOBD_defaultCar_selected"]];
    _normalLabel = [YDUIKit labelWithTextColor:YDBaseColor text:@"我已阅读" fontSize:12 textAlignment:0];
    _hypeTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_hypeTextBtn setTitle:@"遇道用户使用协议" forState:0];
    [_hypeTextBtn setTitleColor:YDBaseColor forState:UIControlStateNormal];
    [_hypeTextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _hypeTextBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_hypeTextBtn addTarget:self action:@selector(hypeTextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self yd_addSubviews:@[_imgV,_normalLabel,_hypeTextBtn]];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(17);
    }];
    [_normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_imgV.mas_right).offset(5);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    [_hypeTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_normalLabel.mas_right).offset(0);
        make.width.mas_lessThanOrEqualTo(100);
        make.right.equalTo(self);
    }];
    UIButton *line = [UIButton buttonWithType:UIButtonTypeCustom];
    [line setBackgroundImage:[UIImage imageWithColor:YDBaseColor] forState:0];
    [line setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_hypeTextBtn);
        make.top.equalTo(_hypeTextBtn.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];
}

@end

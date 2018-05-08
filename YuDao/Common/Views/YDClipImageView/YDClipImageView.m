//
//  YDClipImageView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDClipImageView.h"

@interface YDClipImageView()

@property (nonatomic, strong) UIImageView *clipImageV;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YDClipImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self ci_setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setClipSize:(CGSize)clipSize{
    _clipSize = clipSize;
    
    [_clipImageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_clipSize);
    }];
    
    [self setNeedsLayout];
    
}

- (void)setClipImage:(UIImage *)clipImage{
    _clipImage= clipImage;
    [_clipImageV setImage:clipImage];
}

- (void)setTipTitle:(NSString *)tipTitle{
    _tipTitle = tipTitle;
    
}

- (void)ci_setupSubviews{
    _clipImageV = [UIImageView new];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"请方正凭证，并调整好光线";
    
    _topView = [UIView new];
    _topView.backgroundColor = YDColor(0, 0, 0, 0.4);
    _leftView = [UIView new];
    _leftView.backgroundColor = YDColor(0, 0, 0, 0.4);
    _rightView = [UIView new];
    _rightView.backgroundColor = YDColor(0, 0, 0, 0.4);
    _bottomView = [UIView new];
    _bottomView.backgroundColor = YDColor(0, 0, 0, 0.4);
    
    [self yd_addSubviews:@[_clipImageV,_topView,_leftView,_rightView,_bottomView,_titleLabel]];
    
    [_clipImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(345), kHeight(219)));
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.mas_equalTo(_clipImageV.mas_top);
    }];
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_clipImageV.mas_top);
        make.bottom.equalTo(_clipImageV.mas_bottom);
        make.right.equalTo(_clipImageV.mas_left);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(_clipImageV.mas_top);
        make.bottom.equalTo(_clipImageV.mas_bottom);
        make.left.equalTo(_clipImageV.mas_right);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(_clipImageV.mas_bottom);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_clipImageV.mas_top).offset(-16);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
}

@end

//
//  YDThirdLoginView.m
//  YuDao
//
//  Created by 汪杰 on 2017/5/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDThirdLoginView.h"

@interface YDThirdLoginView()

@property (nonatomic, strong) UIView *lefLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UIButton *rightBtn;


@end

@implementation YDThirdLoginView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
        [self yd_addSubviews:@[self.lefLine,self.titleLabel,self.rightLine]];
        [self addMasonry];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self yd_addSubviews:@[self.lefLine,self.titleLabel,self.rightLine]];
        [self addMasonry];
    }
    return self;
}

#pragma mark - Private Methods
- (void)addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(96, 18));
    }];
    
    [_lefLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.equalTo(self);
        make.right.equalTo(_titleLabel.mas_left).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.equalTo(_titleLabel.mas_right).offset(0);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    
    if ([YDShareManager isInstalledPlatformType:YDThirdPlatformTypeWechat]) {
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_lefLine);
            make.top.equalTo(_lefLine.mas_bottom).offset(21);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleLabel);
            make.top.equalTo(_lefLine.mas_bottom).offset(21);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_rightLine);
            make.top.equalTo(_lefLine.mas_bottom).offset(21);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }else{
        [_leftBtn removeFromSuperview];
        [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titleLabel.mas_left).offset(0);
            make.top.equalTo(_lefLine.mas_bottom).offset(21);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).offset(0);
            make.top.equalTo(_lefLine.mas_bottom).offset(21);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
}

- (void)buttonAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(thirdLoginView:didSelectedPlatform:)]) {
        [self.delegate thirdLoginView:self didSelectedPlatform:button.tag-1000];
    }
}

- (UIView *)lefLine{
    if (!_lefLine) {
        _lefLine = [[UIView alloc] init];
        _lefLine.backgroundColor = [UIColor grayTextColor];
        {
            _rightLine = [[UIView alloc] init];
            _rightLine.backgroundColor = [UIColor grayTextColor];
            _titleLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:13 textAlignment:NSTextAlignmentCenter];
            _titleLabel.text = @"第三方登录";
            _titleLabel.backgroundColor = [UIColor whiteColor];
            _leftBtn = [YDUIKit buttonWithImage:[UIImage imageNamed:@"login_wechat"] selectedImage:[UIImage imageNamed:@"login_wechat"] selector:@selector(buttonAction:) target:self];
            [_leftBtn setImage:YDImage(@"login_wechat_highlight") forState:UIControlStateHighlighted];
            _centerBtn = [YDUIKit buttonWithImage:[UIImage imageNamed:@"login_qq"] selectedImage:[UIImage imageNamed:@"login_qq"] selector:@selector(buttonAction:) target:self];
            [_centerBtn setImage:YDImage(@"login_qq_highlight") forState:UIControlStateHighlighted];
            _rightBtn = [YDUIKit buttonWithImage:[UIImage imageNamed:@"login_weibo"] selectedImage:[UIImage imageNamed:@"login_weibo"] selector:@selector(buttonAction:) target:self];
            [_rightBtn setImage:YDImage(@"login_weibo_hightlight") forState:UIControlStateHighlighted];
            NSArray<UIButton *> *buttons = @[_leftBtn,_centerBtn,_rightBtn];
            [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.tag = 1001 + idx;
                [self addSubview:obj];
            }];
        }
    }
    return _lefLine;
}

@end

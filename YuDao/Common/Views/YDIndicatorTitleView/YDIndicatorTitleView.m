//
//  YDIndicatorTitleView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/8.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDIndicatorTitleView.h"

static NSString *const kIndicatorTitle = @"收取中...";

@interface YDIndicatorTitleView()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign, getter=isShow) BOOL show;

@end

@implementation YDIndicatorTitleView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self it_initSubviews];
        [self it_addMasonry];
    }
    return self;
}

#pragma mark - Public Methods
- (void)show{
    self.show = YES;
    [_indicatorView startAnimating];
    self.hidden = NO;
}

- (void)dismiss{
    if (self.isShow) {
        [_indicatorView stopAnimating];
        self.hidden = YES;
    }
    
}

- (void)it_initSubviews{
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    _indicatorView.hidesWhenStopped = YES;
    
    _titleLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_14] textAlignment:0 backgroundColor:[UIColor clearColor]];
    
    _titleLabel.text = kIndicatorTitle;
    
    [self yd_addSubviews:@[_indicatorView,_titleLabel]];
}

- (void)it_addMasonry{
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_indicatorView.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(100);
    }];
}

@end

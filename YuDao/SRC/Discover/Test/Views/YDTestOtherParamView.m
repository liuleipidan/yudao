//
//  YDTestOtherParamView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/22.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestOtherParamView.h"

@interface YDTestOtherParamView()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *dataLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YDTestOtherParamView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        
        [self op_initSubviews];
        [self op_addMasonry];
        
        _titleLabel.text = title;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self op_initSubviews];
        [self op_addMasonry];
    }
    return self;
}

- (void)setData:(NSString *)data status:(NSString *)status{
    _dataLabel.text = data;
    _statusLabel.text = status;
}

#pragma mark - Private Methods
- (void)op_initSubviews{
    _bgImageView = [[UIImageView alloc] initWithImage:YDImage(@"test_otherdata_bg")];
    
    _dataLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont pingFangSC_MediumFont:16] textAlignment:NSTextAlignmentCenter];
    
    _statusLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    
    _titleLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    
    [self yd_addSubviews:@[_bgImageView,_dataLabel,_statusLabel,_titleLabel]];
}

- (void)op_addMasonry{
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(_bgImageView.mas_width);
    }];
    
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_bgImageView.mas_top).offset(20);
        make.height.mas_equalTo(25);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dataLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_lessThanOrEqualTo(20);
    }];
    
}

@end

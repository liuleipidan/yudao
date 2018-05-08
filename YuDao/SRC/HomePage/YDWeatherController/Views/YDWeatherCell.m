//
//  YDWeatherCell.m
//  YuDao
//
//  Created by 汪杰 on 16/12/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDWeatherCell.h"

@implementation YDWeatherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self y_layoutSubviews];
        
    }
    return self;
}

- (void)y_layoutSubviews{
    [self.contentView addSubview:self.backView];
    
    [self.backView yd_addSubviews:@[self.iconV,self.lineView,self.titleLabel,self.subTitleLabel]];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    [_iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(20);
        make.centerY.equalTo(self.backView);
        make.width.height.mas_equalTo(30);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.bottom.equalTo(self.backView).offset(-10);
        make.left.equalTo(self.iconV.mas_right).offset(16);
        make.width.mas_equalTo(1);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_top);
        make.left.equalTo(self.lineView.mas_right).offset(10);
        make.width.mas_lessThanOrEqualTo(70);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.lineView.mas_right).offset(10);
        make.right.equalTo(self.backView).offset(-10);
    }];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.borderWidth = 1.0f;
        _backView.layer.borderColor = [UIColor blackTextColor].CGColor;
        _backView.layer.cornerRadius = 8.0f;
    }
    return _backView;
}

- (UIImageView *)iconV{
    if (!_iconV) {
        _iconV = [[UIImageView alloc] init];
    }
    return _iconV;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor blackTextColor];
    }
    return _lineView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16]];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    }
    return _subTitleLabel;
}

@end

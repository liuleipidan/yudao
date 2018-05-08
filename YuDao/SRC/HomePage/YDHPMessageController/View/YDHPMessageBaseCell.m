//
//  YDHPMessageBaseCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHPMessageBaseCell.h"

@implementation YDHPMessageBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView yd_addSubviews:@[self.bgImageView,self.icon,self.titleLabel,self.timeLabel,self.detailContent,self.moreBtn,self.bottomLine]];
        
        [self y_addMasonry];
    }
    return self;
}

- (void)setModel:(YDHPMessageModel *)model{
    _model = model;
    _icon.image = YDImage(_model.iconPath);
    _titleLabel.text = _model.title;
    _timeLabel.text = _model.time;
    
}

#pragma mark - Event
- (void)moreButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HPMessageCellMoreButtonClicked:rect:)]) {
        CGRect rect =  [self convertRect:sender.frame toView:[UIApplication sharedApplication].keyWindow];
        [self.delegate HPMessageCellMoreButtonClicked:self.model rect:rect];
    }
}

- (void)y_addMasonry{
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(26);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_icon.mas_top).offset(-5);
        make.left.equalTo(_icon.mas_right).offset(8);
        make.height.mas_equalTo(18);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_icon.mas_bottom).offset(5);
        make.left.equalTo(_titleLabel);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(self.contentView).offset(0);
        make.height.width.mas_equalTo(40);
    }];
 
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    
    [_detailContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_timeLabel.mas_bottom);
        make.bottom.equalTo(_bottomLine.mas_top);
    }];
    
}

#pragma mark - Getter
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelTextColor:[UIColor grayTextColor] fontSize:13];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [YDUIKit labelTextColor:[UIColor grayTextColor] fontSize:12];
    }
    return _timeLabel;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"homePage_message_more"] forState:0];
        [_moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIView *)detailContent{
    if (!_detailContent) {
        _detailContent = [[UIView alloc] init];
        _detailContent.backgroundColor = [UIColor clearColor];
    }
    return _detailContent;
}
- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor searchBarBackgroundColor];
    }
    return _bottomLine;
}

@end

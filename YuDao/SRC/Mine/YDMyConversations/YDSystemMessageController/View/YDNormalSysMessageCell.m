//
//  YDAuthSuccessSysMessageCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDNormalSysMessageCell.h"

@interface YDNormalSysMessageCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation YDNormalSysMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.borderView yd_addSubviews:@[self.titleLabel,self.contentLabel]];
        
        [self as_addMasonry];
    }
    return self;
}

- (void)setMessage:(YDSystemMessage *)message{
    [super setMessage:message];
    
    _titleLabel.text = message.title;
    _contentLabel.text = message.text;
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(message.textHeight);
    }];
    
}
- (void)as_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_borderView).offset(15);
        make.top.equalTo(_borderView).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 50);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.right.equalTo(_borderView).offset(-15);
    }];
}

#pragma mark - Getters
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16]];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14]];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end

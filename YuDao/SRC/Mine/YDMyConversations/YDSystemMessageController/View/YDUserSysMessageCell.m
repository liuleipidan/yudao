//
//  YDUserSysMessageCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDUserSysMessageCell.h"

@interface YDUserSysMessageCell()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation YDUserSysMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.borderView yd_addSubviews:@[self.avatarImageView,self.titleLabel,self.subTitleLabel]];
        
        [self us_addMasonry];
    }
    return self;
}

- (void)setMessage:(YDSystemMessage *)message{
    [super setMessage:message];
    
    [_avatarImageView yd_setImageFadeinWithString:message.avatarURL];
    _titleLabel.text = message.nickname;
    _subTitleLabel.text = message.text;
}

#pragma mark - Private Methods
- (void)us_addMasonry{
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_borderView);
        make.left.equalTo(_borderView).offset(15);
        make.width.height.mas_equalTo(50);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top).offset(2);
        make.left.equalTo(_avatarImageView.mas_right).offset(15);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-110);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView.mas_bottom).offset(-1);
        make.left.equalTo(_titleLabel.mas_left);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-110);
    }];
    
}

#pragma mark - Getters
- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 25.0f;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16]];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (_subTitleLabel == nil) {
        _subTitleLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14]];
    }
    return _subTitleLabel;
}

@end

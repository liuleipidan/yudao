//
//  YDPhoneContactsCell.m
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPhoneContactsCell.h"

#define     FRIENDS_SPACE_X         10.0f

#define     FRIENDS_SPACE_Y         9.0f

@interface YDPhoneContactsCell()

@property (nonatomic, strong) UIImageView *avatarImgV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation YDPhoneContactsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView yd_addSubviews:@[self.avatarImgV,self.titleLabel,self.subTitleLabel,self.rightBtn]];
        
        [self y_addMasonry];
    }
    return self;
}

- (void)setModel:(YDContactsModel *)model{
    _model = model;
    
    if (model.avatarPath) {
        NSString *path = [NSFileManager pathContactsAvatar:model.avatarPath];
        [_avatarImgV setImage:[UIImage imageNamed:path]];
    }else{
        [_avatarImgV yd_setImageWithString:model.avatarURL placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    }
    
    _titleLabel.text = model.name;
    
    if (model.nickName) {
        _subTitleLabel.text = [NSString stringWithFormat:@"遇道: %@",model.nickName];
    }else{
        _subTitleLabel.text = [NSString stringWithFormat:@"手机号: %@",model.phoneNumber];
    }
    
    switch (model.status) {
        case YDContactStatusNotJoin:
        {
            _rightBtn.backgroundColor = [UIColor whiteColor];
            _rightBtn.layer.borderColor = [UIColor orangeTextColor].CGColor;
            [_rightBtn setTitle:@"邀请加入" forState:0];
            [_rightBtn setTitleColor:[UIColor orangeTextColor] forState:UIControlStateNormal];
            break;}
        case YDContactStatusStranger:
        {
            _rightBtn.backgroundColor = [UIColor orangeTextColor];
            _rightBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_rightBtn setTitle:@"加为好友" forState:0];
            break;}
        case YDContactStatusFriend:
        {
            _rightBtn.backgroundColor = [UIColor clearColor];
            _rightBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [_rightBtn setTitle:@"已添加" forState:0];
            [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:0];
            break;}
        case YDContactStatusWait:
        {
            _rightBtn.backgroundColor = [UIColor clearColor];
            _rightBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [_rightBtn setTitle:@"等待验证" forState:0];
            [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:0];
            break;}
            
        default:
            break;
    }
    
}
//点击添加按钮
- (void)phoneContactsCellAddButtonAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneContactsCell:touchedButton:model:)]) {
        [self.delegate phoneContactsCell:self touchedButton:button model:self.model];
    }
}

- (void)y_addMasonry{
    [_avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FRIENDS_SPACE_X);
        make.top.mas_equalTo(FRIENDS_SPACE_Y);
        make.bottom.mas_equalTo(-FRIENDS_SPACE_Y + 0.5);
        make.width.mas_equalTo(_avatarImgV.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_avatarImgV.mas_right).mas_offset(FRIENDS_SPACE_X);
        make.top.mas_equalTo(_avatarImgV).offset(-1);
        make.right.mas_lessThanOrEqualTo(_rightBtn.mas_left).offset(-10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(2);
        make.right.mas_lessThanOrEqualTo(_rightBtn.mas_left).offset(-10);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-5);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(60);
    }];
}

- (UIImageView *)avatarImgV{
    if (!_avatarImgV) {
        _avatarImgV = [[UIImageView alloc] init];
    }
    return _avatarImgV;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:16];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [YDUIKit labelTextColor:[UIColor grayTextColor] fontSize:14];
    }
    return _subTitleLabel;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitleColor:[UIColor orangeTextColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor orangeTextColor] forState:UIControlStateHighlighted];
        _rightBtn.layer.borderColor = [UIColor orangeTextColor].CGColor;
        _rightBtn.layer.borderWidth = 1.0f;
        _rightBtn.layer.cornerRadius = 2.f;
        [_rightBtn.titleLabel setFont:[UIFont font_12]];
        
        [_rightBtn addTarget:self action:@selector(phoneContactsCellAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end

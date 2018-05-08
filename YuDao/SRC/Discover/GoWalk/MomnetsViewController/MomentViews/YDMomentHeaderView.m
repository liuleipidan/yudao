//
//  YDMomentHeaderView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentHeaderView.h"

@interface YDMomentHeaderView()

@property (nonatomic, strong) UIButton *avatarBtn;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation YDMomentHeaderView

- (instancetype)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self mh_setupSubviews];
        [self mh_addMasonry];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setMomentUserInfo:(YDMoment *)moment{
    
    [_avatarBtn sd_setImageWithURL:YDURL(moment.ud_face) forState:0 placeholderImage:YDImage([moment.ud_sex isEqual:@1] ? kDefaultAvatarPathMale : kDefaultAvatarPath)];
    
    _nameLabel.text = moment.ub_nickname;
    _timeLabel.text = moment.showTime;
    
    if ([moment.ub_id isEqual:YDUser_id] || [moment.friend isEqual:@2]) {
        _rightBtn.hidden = YES;
    }
    else{
        _rightBtn.hidden = NO;
        BOOL exsit = [YDDBSendFriendRequestStore checkSenderFriendRequsetExistOrNeedDeleteBySenderID:[YDUserDefault defaultUser].user.ub_id receiverID:moment.ub_id];
        if (exsit) {
            [_rightBtn setTitle:@"已申请" forState:0];
        }else{
            [_rightBtn setTitle:@"加好友" forState:0];
        }
    }
}

#pragma mark - Events
- (void)mh_avatarButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(momentHedaerViewClickUserAvatar:)]) {
        [self.delegate momentHedaerViewClickUserAvatar:nil];
    }
    
}

- (void)mh_rightButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(momentHedaerViewClickRightButton:moment:)]) {
        [self.delegate momentHedaerViewClickRightButton:sender moment:nil];
    }
}

- (void)mh_setupSubviews{
    _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_avatarBtn addTarget:self action:@selector(mh_avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _avatarBtn.backgroundColor = [UIColor whiteColor];
    _avatarBtn.layer.cornerRadius = 25.f;
    _avatarBtn.clipsToBounds = YES;
    
    _nameLabel = [YDUIKit labelTextColor:[UIColor blackTextColor] fontSize:16];
    
    _timeLabel = [YDUIKit labelTextColor:[UIColor grayTextColor] fontSize:12];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_rightBtn setImage:@"dynamic_addFriend" imageHL:@"dynamic_addFriend"];
    [_rightBtn addTarget:self action:@selector(mh_rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.layer.cornerRadius = 3.0;
    _rightBtn.layer.borderWidth = 1.0f;
    [_rightBtn setTitle:@"加好友" forState:0];
    [_rightBtn setTitle:@"已申请" forState:UIControlStateDisabled];
    [_rightBtn setTitleColor:[UIColor blackTextColor] forState:0];
    [_rightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    
    [self yd_addSubviews:@[_avatarBtn,_nameLabel,_timeLabel,_rightBtn]];
}

- (void)mh_addMasonry{
    [_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(_avatarBtn.mas_height);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarBtn.mas_top).offset(3);
        make.left.equalTo(_avatarBtn.mas_right).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_avatarBtn.mas_bottom).offset(-3);
        make.left.equalTo(_nameLabel);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_avatarBtn);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(69, 22));
    }];
    
}

@end

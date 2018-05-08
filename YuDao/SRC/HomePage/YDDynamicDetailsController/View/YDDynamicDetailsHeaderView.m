//
//  YDDynamicDetailsHeaderView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/20.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDynamicDetailsHeaderView.h"

@interface YDDynamicDetailsHeaderView()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *lookNumberLabel;

@property (nonatomic, strong) UILabel *lookLabel;

@property (nonatomic, strong) UIView *lookBgView;

@end

@implementation YDDynamicDetailsHeaderView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self dh_initSubviews];
        [self dh_addMasonry];
        
    }
    return self;
}

- (void)setItem:(YDDynamicDetailModel *)item{
    _item = item;
    
    [_avatarImageView yd_setImageWithString:item.ud_face placeholaderImageString:[item.ud_sex isEqual:@1] ? kDefaultAvatarPathMale : kDefaultAvatarPath];
    
    _nameLabel.text = item.ub_nickname;
    
    _lookNumberLabel.text = [NSString stringWithFormat:@"%@",YDNoNilNumber(item.d_look)];
    
    _timeLabel.text = [NSDate timeInfoWithDate:item.d_issuetimeInt];
    
    _lookBgView.hidden = item == nil;
}

#pragma mark - Events
- (void)dh_tapAvatarImageView:(UITapGestureRecognizer *)tap{
    if (self.DHClickedAvatarBlock) {
        self.DHClickedAvatarBlock(self.item);
    }
}

#pragma mark - Private Methods
- (void)dh_initSubviews{
    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.cornerRadius = 25.0f;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.userInteractionEnabled = YES;
    [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dh_tapAvatarImageView:)]];
    
    _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    _timeLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12]];
    
    _lookLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:9] textAlignment:NSTextAlignmentCenter];
    _lookLabel.text = @"阅读";
    
    _lookNumberLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter];
    
    _lookBgView = [UIView new];
    _lookBgView.layer.cornerRadius = 3.f;
    _lookBgView.layer.borderWidth = 0.5f;
    _lookBgView.layer.borderColor = [UIColor grayTextColor1].CGColor;
    _lookBgView.hidden = YES;
    [_lookBgView yd_addSubviews:@[_lookNumberLabel,_lookLabel]];
    
    [self yd_addSubviews:@[_avatarImageView,_nameLabel,_timeLabel,_lookBgView]];
}

- (void)dh_addMasonry{
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.height.mas_equalTo(50);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top).offset(3);
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView.mas_bottom).offset(-3);
        make.left.equalTo(_nameLabel.mas_left);
        make.height.mas_equalTo(12);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_lookBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 25));
    }];
    
    [_lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_lookBgView);
        //make.height.mas_equalTo(13);
    }];
    
    [_lookNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_lookBgView);
        //make.height.mas_equalTo(17);
    }];
}

@end

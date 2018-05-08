//
//  YDFriendCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/29.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDFriendCell.h"

@interface YDFriendCell ()

//标记
@property (nonatomic, strong) UILabel *remindLabel;

@end

@implementation YDFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView yd_addSubviews:@[self.avatarImageView,self.usernameLabel,self.remindLabel]];
        
        [self fc_addMasory];
        
    }
    return self;
}

- (void)setItem:(YDFriendModel *)item{
    _item = item;
    
    if (item.avatarPath.length > 0) {
        [_avatarImageView setImage:YDImage(item.avatarPath)];
    }
    else{
        [_avatarImageView yd_setImageWithString:item.friendImage placeholaderImageString:kDefaultAvatarPath];
    }
    
    _usernameLabel.text = item.friendName;
    
}

- (void)markRemindLabelCount:(NSUInteger)count{
    if (count == 0) {
        _remindLabel.text = @"";
        _remindLabel.hidden = YES;
    }
    else{
        _remindLabel.text = [NSString stringWithFormat:@"%lu",count];
        _remindLabel.hidden = NO;
    }
}

#pragma mark - Private Methods
- (void)fc_addMasory{
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(kUserAvatarHeight);
    }];
    
    [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 80);
    }];
    
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.height.mas_equalTo(kRedPoint_Width);
    }];
}

- (void)fc_avatarImageViewTapAction:(UIGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCell:didClickAvatarImageView:)]) {
        [self.delegate friendCell:self didClickAvatarImageView:(UIImageView *)tap.view];
    }
}

#pragma mark - Getters
- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = kUserAvatarHeight/2.0;
        _avatarImageView.clipsToBounds = YES;
        
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fc_avatarImageViewTapAction:)]];
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    }
    return _usernameLabel;
}

- (UILabel *)remindLabel{
    if (_remindLabel == nil) {
        _remindLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor redColor]];
        _remindLabel.layer.cornerRadius = kRedPoint_Width / 2.0;
        _remindLabel.clipsToBounds = YES;
        _remindLabel.hidden = YES;
        _remindLabel.text = @"";
    }
    return _remindLabel;
}

@end

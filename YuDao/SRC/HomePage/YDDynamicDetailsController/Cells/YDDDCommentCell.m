//
//  YDDDCommentCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDDCommentCell.h"

@interface YDDDCommentCell ()

//头像
@property (nonatomic, strong) UIImageView *avatarImageView;
//名字
@property (nonatomic, strong) UILabel *nameLabel;
//内容
@property (nonatomic, strong) UILabel *contentLabel;
//时间
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YDDDCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self cc_initSubviews];
        [self cc_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setModel:(YDDynamicCommentModel *)model{
    _model = model;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.ud_face] placeholderImage:[UIImage imageNamed:kDefaultAvatarPath]];
    self.nameLabel.text = model.ub_nickname;
    [self.contentLabel setAttributedText:model.detailsAttr];
    self.timeLabel.text = model.timeInfo;
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_lessThanOrEqualTo(model.height);
    }];
}

#pragma mark - Events
- (void)cc_didClickedAvatar:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(commentCell:didSelectedAvatar:)]) {
        [_delegate commentCell:self didSelectedAvatar:self.avatarImageView];
    }
}

#pragma mark - Private Methods
- (void)cc_initSubviews{
    _avatarImageView = [UIImageView new];
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.aliCornerRadius = 20.0f;
    [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cc_didClickedAvatar:)]];
    
    _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    
    _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _contentLabel.numberOfLines = 0;
    
    _timeLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:10] textAlignment:NSTextAlignmentRight];
    
    [self.contentView yd_addSubviews:@[_avatarImageView,_nameLabel,_contentLabel,_timeLabel]];
}

- (void)cc_addMasonry{
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top);
        make.left.equalTo(_avatarImageView.mas_right).offset(5);
        make.height.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(0);
        make.left.equalTo(_nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_lessThanOrEqualTo(50);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(150);
    }];
}



@end

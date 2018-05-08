//
//  YDDynamicMessageCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDynamicMessageCell.h"

@interface YDDynamicMessageCell()

/**
 头像
 */
@property (nonatomic, strong) UIImageView *avatarImageView;

/**
 名字
 */
@property (nonatomic, strong) UILabel *mainLabel;

/**
 评论内容，若是点赞则隐藏
 */
@property (nonatomic, strong) UILabel *subLabel;

/**
 点赞❤️，若是评论则隐藏
 */
@property (nonatomic, strong) UIImageView *subImageView;

/**
 右侧被评论或点赞的动态第一张图
 */
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation YDDynamicMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self dmc_initSubviews];
        [self dmc_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setMessage:(YDDynamicMessage *)message{
    _message = message;
    
    [_avatarImageView yd_setImageWithString:message.ud_face placeholaderImageString:kDefaultAvatarPath];
    
    _mainLabel.text = message.nickName;
    
    [_rightImageView yd_setImageFadeinWithString:message.d_image];
    
    //评论
    if ([message.type isEqual:@1]) {
        _subLabel.hidden = NO;
        _subImageView.hidden = YES;
        if ([message.status isEqual:@1]) {
            _subLabel.text = message.conmentContent;
            _subLabel.backgroundColor = [UIColor whiteColor];
        }else{
            _subLabel.text = @"该评论已被删除";
            _subLabel.backgroundColor = YDColorString(@"#F0F0F0");
        }
    }
    else{//点赞
        _subLabel.hidden = YES;
        _subImageView.hidden = NO;
    }
}

#pragma mark - Private Methods
- (void)dmc_initSubviews{
    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.cornerRadius = 25.0f;
    _avatarImageView.clipsToBounds = YES;
    
    _mainLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    
    _subLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    _subLabel.layer.cornerRadius = 5;
    _subLabel.clipsToBounds = YES;
    
    _subImageView = [UIImageView new];
    
    _subImageView.image = YDImage(@"dynamic_likeButton_normal");
    
    _rightImageView = [UIImageView new];
    
    [self.contentView yd_addSubviews:@[_avatarImageView,_mainLabel,_subLabel,_subImageView,_rightImageView]];
}

- (void)dmc_addMasonry{
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.right.equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(_rightImageView.mas_height);
    }];
    
    [_mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top).offset(2);
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(195);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView.mas_bottom).offset(-1);
        make.left.equalTo(_mainLabel.mas_left);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(195);
    }];
    
    [_subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_subLabel.mas_bottom);
        make.left.equalTo(_mainLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
}

@end

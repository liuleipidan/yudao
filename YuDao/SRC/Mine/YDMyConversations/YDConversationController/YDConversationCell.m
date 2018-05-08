//
//  YDConversationCell.m
//  YuDao
//
//  Created by 汪杰 on 17/2/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDConversationCell.h"

@interface YDConversationCell()

@property (nonatomic, strong) UIImageView *headerImageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YDConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self cc_initSubviews];
        [self cc_addMasonry];
        
    }
    return self;
}

- (void)setModel:(YDConversation *)model{
    _model = model;
    
    if (model.avatarPath.length > 0) {
        _headerImageV.image = [UIImage imageNamed:model.avatarPath];
    }
    else{
        [_headerImageV yd_setImageWithString:model.fimageUrl placeholaderImageString:kDefaultAvatarPath];
    }
    
    _titleLabel.text = model.fname;
    
    [_subTitleLabel setAttributedText:model.attrContent];
    
    _timeLabel.text = model.timeInfo;
    
    model.unreadCount > 0 ? [self markAsUnread] : [self markAsRead];
}

- (void)markAsUnread{
    _remindLabel.hidden = NO;
    _remindLabel.text = [NSString stringWithFormat:@"%ld",self.model.unreadCount];
}

/**
 *  标记为已读
 */
- (void)markAsRead{
    _remindLabel.text = @"";
    _remindLabel.hidden = YES;
}

#pragma mark - Private Methods
- (void)cc_initSubviews{
    _headerImageV = [UIImageView new];
    _headerImageV.layer.cornerRadius = kUserAvatarHeight / 2.0;
    _headerImageV.clipsToBounds = YES;
    
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    
    _subTitleLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    
    _timeLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentRight backgroundColor:[UIColor whiteColor]];
    
    _remindLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor redColor]];
    _remindLabel.layer.cornerRadius = kRedPoint_Width / 2.0;
    _remindLabel.clipsToBounds = YES;
    _remindLabel.hidden = YES;
    _remindLabel.text = @"";
    
    [self.contentView yd_addSubviews:@[_headerImageV,_titleLabel,_subTitleLabel,_timeLabel,_remindLabel]];
}

- (void)cc_addMasonry{
    
    [_headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(kUserAvatarHeight);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageV.mas_top);
        make.left.equalTo(self.headerImageV.mas_right).offset(10);
        make.height.mas_equalTo(21);
        make.right.equalTo(self.contentView).offset(-90);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImageV.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.timeLabel.mas_left).offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.subTitleLabel);
        make.right.equalTo(self.timeLabel.mas_right);
        make.width.height.mas_equalTo(kRedPoint_Width);
    }];
    
}



@end

//
//  YDSingleRankingListCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSingleRankingListCell.h"

@interface YDSingleRankingListCell()

@property (nonatomic, strong) UILabel *rankingLabel;

@property (nonatomic, strong) UIImageView *rankingIcon;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *locationIcon;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UILabel *dataLabel;

@property (nonatomic, strong) YDSingleRLLikeButton *likeButton;

@end

@implementation YDSingleRankingListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self srl_initSubviews];
        [self srl_addMasonry];
        
        [self setLineColor:[UIColor tableViewSectionHeaderViewBackgoundColor]];
        [self setLeftSeparatorSpace:49.0];
        [self setRightSeparatorSpace:20.0];
    }
    return self;
}

- (void)setItem:(YDRankingListModel *)item{
    _item = item;
    
    _rankingLabel.text = item.rankingText;
    if (item.rankingIconPath) {
        _rankingIcon.image = [UIImage imageNamed:item.rankingIconPath];
        _rankingLabel.textColor = [UIColor whiteColor];
    }
    else{
        _rankingIcon.image = nil;
        _rankingLabel.textColor = [UIColor blackTextColor];
    }
    
    
    [_avatarImageView yd_setImageWithString:item.ud_face placeholaderImageString:[item.ud_sex isEqual:@1] ? kDefaultAvatarPathMale : kDefaultAvatarPath];
    
    _nameLabel.text = item.ub_nickname;
    
    _locationLabel.text = item.address;
    
    _dataLabel.text = item.dataString;
    
    [_likeButton setTitle:[NSString stringWithFormat:@"%@",item.likenum]];
    [_likeButton setSelected:[item.taplike isEqual:@2]];
    
}

#pragma mark - Event
- (void)srl_likeButtonAction:(YDSingleRLLikeButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(singleRankingListCell:didClickedLikeButton:)]) {
        [_delegate singleRankingListCell:self didClickedLikeButton:sender];
    }
}

#pragma mark - Private Methods
- (void)srl_initSubviews{
    _rankingLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16] textAlignment:NSTextAlignmentCenter];
    
    _rankingIcon = [UIImageView new];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.cornerRadius = 8.0f;
    _avatarImageView.clipsToBounds = YES;
    
    _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16]];
    
    _locationIcon = [[UIImageView alloc] initWithImage:YDImage(@"dynamic_location_icon")];
    
    _locationLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12]];
    
    _dataLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16] textAlignment:NSTextAlignmentRight];
    
    _likeButton = [[YDSingleRLLikeButton alloc] initWithTitle:@"0" iconPath:@"dynamic_likeButton_normal" iconHLPath:@"dynamic_likeButton_selected"];
    [_likeButton addTarget:self action:@selector(srl_likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView yd_addSubviews:@[_rankingIcon,_rankingLabel,_avatarImageView,_nameLabel,_locationIcon,_locationLabel,_dataLabel,_likeButton]];
}

- (void)srl_addMasonry{
    UIView *contenView = self.contentView;
    [_rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_rankingIcon).insets(UIEdgeInsetsMake(0, 0, 6, 0));
    }];
    
    [_rankingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contenView).offset(15);
        make.centerY.equalTo(contenView);
        make.size.mas_equalTo(CGSizeMake(18, 24));
    }];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contenView);
        make.left.equalTo(contenView).offset(49);
        make.width.height.mas_equalTo(50);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.top.equalTo(_avatarImageView.mas_top).offset(4);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.bottom.equalTo(_avatarImageView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(10, 13));
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_locationIcon);
        make.left.equalTo(_locationIcon.mas_right).offset(5);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contenView);
        make.right.equalTo(contenView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(21, 38));
    }];
    
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contenView);
        make.right.equalTo(_likeButton.mas_left).offset(-20);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
}

@end

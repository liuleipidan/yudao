//
//  YDHPDynamicCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDHPDynamicCell.h"
#import "YDCustomButton.h"

@interface YDHPDynamicCell()

//动态第一张图
@property (nonatomic, strong) UIImageView *fisrtImageView;

//用户头像
@property (nonatomic, strong) UIImageView *avatarImageView;

//用户昵称
@property (nonatomic, strong) UILabel *nameLabel;

//动态内容
@property (nonatomic, strong) UILabel *contentLabel;//内容

//定位
@property (nonatomic, strong) YDCustomButton *locationButton;

//播放按钮
@property (nonatomic, strong) UIButton *playButton;

@end

@implementation YDHPDynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self dc_initSubviews];
        [self dc_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Method
- (void)setModel:(YDDynamicModel *)model{
    if (_model
        && [_model isEqual:model]) {
        return;
    }
    
    _model = model;
    
    [_fisrtImageView yd_setImageWithString:model.imageUrl showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _playButton.hidden = [model.d_type isEqual:@2] ? NO : YES;
    
    [_avatarImageView yd_setImageWithString:model.ud_face placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _nameLabel.text = model.u_name;
    
    _contentLabel.text = model.d_details;
    
    [_locationButton setTitle:model.d_address];
    _locationButton.hidden = [model.d_hide isEqual:@1];
    
    if (model.d_details.length != 0) {
        [_locationButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(6);
        }];
    }
    else{
        [_locationButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        }];
    }
}


#pragma mark - Events
//点击播放
- (void)dc_playButtonAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(HPDynamicCell:didClickedPlayButton:)]) {
        [_delegate HPDynamicCell:self didClickedPlayButton:self.model];
    }
}
//点击用户头像
- (void)dc_didClickedUserAvatar:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(HPDynamicCell:didClickedUserAvatar:)]) {
        [_delegate HPDynamicCell:self didClickedUserAvatar:self.model];
    }
}
#pragma mark - Private Methods
- (void)dc_initSubviews{
    _fisrtImageView = [[UIImageView alloc] init];
    _fisrtImageView.backgroundColor = [UIColor grayBackgoundColor];
    _fisrtImageView.clipsToBounds = YES;
    _fisrtImageView.layer.cornerRadius = 8.0f;
    _fisrtImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:YDImage(@"video_icon_play") forState:0];
    _playButton.hidden = YES;
    [_playButton addTarget:self action:@selector(dc_playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _avatarImageView = [[UIImageView alloc] initWithRoundingRectImageView];
    
    [_avatarImageView zy_attachBorderWidth:1.5 color:[UIColor whiteColor]];
    _avatarImageView.userInteractionEnabled = YES;
    [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(dc_didClickedUserAvatar:)]];
    
    _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:14]];
    
    _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _contentLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    _locationButton = [[YDCustomButton alloc] initWithTitle:@"" iconPath:@"discover_pd_location" iconHLPath:@"discover_pd_location" iconType:YDCustomButtonIconTypeLeft];
    
    [self.contentView yd_addSubviews:@[_fisrtImageView,_playButton,_avatarImageView,_nameLabel,_contentLabel,_locationButton]];
}

- (void)dc_addMasonry{
    [_fisrtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo((SCREEN_WIDTH - 20) * 0.56);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_fisrtImageView);
        make.width.height.mas_equalTo(50);
    }];
    
    CGFloat headerWidth = (SCREEN_WIDTH - 20) * 0.15;
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-39);
        make.top.equalTo(_fisrtImageView.mas_bottom).offset(-headerWidth / 2.0);
        make.width.height.mas_equalTo(headerWidth);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fisrtImageView.mas_bottom).offset(5);
        make.right.equalTo(_avatarImageView).offset(-5);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(22);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(21);
    }];
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(18);
    }];
}

@end

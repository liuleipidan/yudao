//
//  YDMineHeaderBlurView.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMineHeaderBlurView.h"
#import "FXBlurView.h"

@interface YDMineHeaderBlurView()

//黑色透明层，默认alpha = 0.4
@property (nonatomic, strong) UIView *overView;

//二维码
@property (nonatomic, strong) UIImageView *erCodeImageView;

//常出没地+性别+星座
@property (nonatomic, strong) UILabel *detailsLabel;

//昵称
@property (nonatomic, strong) UILabel *nameLabel;

//等级
@property (nonatomic, strong) UILabel *levelLabel;

//被喜欢的人数
@property (nonatomic, strong) UILabel *likeLabel;

//积分
@property (nonatomic, strong) UILabel *scoreLabel;

//左分割线
@property (nonatomic, strong) UIView *leftLine;

//右分割线
@property (nonatomic, strong) UIView *rightLine;

@end

@implementation YDMineHeaderBlurView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mh_initSubviews];
        [self mh_addMasonry];
        
    }
    return self;
}

- (void)setUserInfo:(YDUser *)userInfo{
    
    [_bgImageView yd_setImageFadeinWithString:userInfo.ud_background];
    
    [_avatarImageView yd_setImageWithString:userInfo.ud_face placeholaderImageString:[userInfo.ud_sex isEqual:@1] ? kDefaultAvatarPathMale : kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    
    NSString *details = userInfo.ud_sex.integerValue == 1 ? @"男生" : @"女生";
    if (userInfo.ud_constellation.length > 0) {
        details = [NSString stringWithFormat:@"%@\n%@",details,userInfo.ud_constellation];
    }
    if (userInfo.ud_often_province_name.length > 0) {
        details = [NSString stringWithFormat:@"%@·%@",userInfo.oftenPlace_1,details];
    }
    
    _detailsLabel.text = details;
    
    _nameLabel.text = userInfo.ub_nickname;
    
    [_levelLabel yd_setText:[NSString stringWithFormat:@"V%@\n%@",userInfo.ub_auth_grade,@"等级"] lineSpace:1];
    
    //同步喜欢的人
    [YDUserDefault requestLikeMyselfNumber:^(NSNumber *num) {
        [self.likeLabel yd_setText:[NSString stringWithFormat:@"%@\n%@",num,@"喜欢"] lineSpace:1];
    }];
    
    [_scoreLabel yd_setText:[NSString stringWithFormat:@"%@\n%@",userInfo.ud_credit,@"积分"] lineSpace:1];
    
    _userInfo = userInfo;
}

#pragma mark - Events
- (void)mh_clickedUserAvatar:(UIGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderBlurView:clickedUserAvatar:)]) {
        [self.delegate mineHeaderBlurView:self clickedUserAvatar:(UIImageView *)tap.view];
    }
}

- (void)mh_clickedUserBackgroundImage:(UIGestureRecognizer *)tap{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderBlurView:clickedBackgroundImageView:)]) {
        [self.delegate mineHeaderBlurView:self clickedBackgroundImageView:self.bgImageView];
    }
}

- (void)mh_clickedErCode:(UIGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderBlurView:clickedErCode:)]) {
        [self.delegate mineHeaderBlurView:self clickedErCode:(UIImageView *)tap.view];
    }
}

- (void)mh_clickedLikeNumLabel:(UIGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderBlurViewClickedLikeLabel:)]) {
        [self.delegate mineHeaderBlurViewClickedLikeLabel:self];
    }
}

- (void)mh_clickedScoreNumLabel:(UIGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderBlurViewClickedScoreLabel:)]) {
        [self.delegate mineHeaderBlurViewClickedScoreLabel:self];
    }
}

#pragma mark - Private Methods
- (void)mh_initSubviews{
    //背景
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor whiteColor];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    
    //覆盖层
    _overView = [[UIView alloc] init];
    _overView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [_overView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mh_clickedUserBackgroundImage:)]];
    
    //内容
    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.borderWidth = 1;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.layer.cornerRadius = kWidth(100) / 2.0;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.userInteractionEnabled = YES;
    [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mh_clickedUserAvatar:)]];
    
    _erCodeImageView = [UIImageView new];
    _erCodeImageView.image = YDImage(@"mine_homePage_erCode");
    _erCodeImageView.userInteractionEnabled = YES;
    [_erCodeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mh_clickedErCode:)]];
    
    _detailsLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    _detailsLabel.numberOfLines = 0;
    
    _nameLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_16] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    
    _levelLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont pingFangSC_MediumFont:16] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    _levelLabel.numberOfLines = 2;
    
    _likeLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont pingFangSC_MediumFont:16] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    _likeLabel.numberOfLines = 2;
    _likeLabel.userInteractionEnabled = YES;
    [_likeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mh_clickedLikeNumLabel:)]];
    //设置喜欢的缓存值
    [_likeLabel yd_setText:[NSString stringWithFormat:@"%@\n%@",[YDUserDefault defaultUser].user.likeNum,@"喜欢"] lineSpace:1];
    
    _scoreLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont pingFangSC_MediumFont:16] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    _scoreLabel.numberOfLines = 2;
    _scoreLabel.userInteractionEnabled = YES;
    [_scoreLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mh_clickedScoreNumLabel:)]];
    
    _leftLine = [UIView new];
    _leftLine.backgroundColor = [UIColor whiteColor];
    
    _rightLine = [UIView new];
    _rightLine.backgroundColor = [UIColor whiteColor];
    
    [self yd_addSubviews:@[_bgImageView,_overView,_avatarImageView,_erCodeImageView,_detailsLabel,_nameLabel,_levelLabel,_likeLabel,_scoreLabel,_leftLine,_rightLine]];
    
}

- (void)mh_addMasonry{
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_overView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kHeight(61));
        make.width.height.mas_equalTo(kWidth(100));
    }];
    
    //占位图，让二维码相对居中
    UIView *leftPlaceholderView = [UIView new];
    UIView *rightPlaceholderView = [UIView new];
    [self yd_addSubviews:@[leftPlaceholderView,rightPlaceholderView]];
    [leftPlaceholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.avatarImageView);
        make.right.equalTo(self.avatarImageView.mas_left);
        make.height.mas_equalTo(0);
    }];
    [rightPlaceholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.avatarImageView);
        make.left.equalTo(self.avatarImageView.mas_right);
        make.height.mas_equalTo(0);
    }];
    
    [_erCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.centerX.equalTo(leftPlaceholderView);
        make.centerY.equalTo(self.avatarImageView);
    }];
    
    [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_lessThanOrEqualTo(40);
        make.centerY.equalTo(self.avatarImageView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarImageView);
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(13);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-20);
    }];
    
    NSArray *lines = @[_leftLine,_rightLine];
    CGFloat leadSpace = (SCREEN_WIDTH - 2) / 3;
    [lines mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:1 leadSpacing:leadSpace tailSpacing:leadSpace];
    [lines mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(kHeight(64));
        make.height.mas_equalTo(24);
    }];
    
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.leftLine.mas_left).offset(-10);
        make.centerY.equalTo(self.leftLine);
        make.height.mas_equalTo(40);
    }];
    
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLine.mas_right).offset(5);
        make.right.equalTo(self.rightLine.mas_left).offset(-5);
        make.centerY.equalTo(self.leftLine);
        make.height.mas_equalTo(40);
    }];
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(self.rightLine.mas_right).offset(10);
        make.centerY.equalTo(self.leftLine);
        make.height.mas_equalTo(40);
    }];
    
}

@end

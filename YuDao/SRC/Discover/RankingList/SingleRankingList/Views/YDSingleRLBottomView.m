//
//  YDSingleRLBottomView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDSingleRLBottomView.h"

@interface YDSingleRLBottomView()

@property (nonatomic, strong) UILabel *rankingLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *locationIcon;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UILabel *dataLabel;

@property (nonatomic, strong) YDSingleRLLikeButton *likeButton;

@end

@implementation YDSingleRLBottomView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor shadowColor].CGColor;
        self.layer.shadowOpacity = 0.8f;
        self.layer.shadowOffset = CGSizeMake(0.0,0.0);
        
        [self srl_initSubviews];
        [self srl_addMasonry];
        
    }
    return self;
}

- (void)showWithAnimation:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        self.alpha = 1;
    }
}

- (void)dismissWithAnimation:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        self.alpha = 0;
    }
}

- (void)setItem:(YDRankingListModel *)item{
    if (item == nil) {
        return;
    }
    
    _item = item;
    
    _rankingLabel.text = item.rankingText;
    
    [_avatarImageView yd_setImageWithString:item.ud_face placeholaderImageString:[item.ud_sex isEqual:@1] ? kDefaultAvatarPathMale : kDefaultAvatarPath];
    
    _nameLabel.text = item.ub_nickname;
    
    _locationLabel.text = item.address;
    
    _dataLabel.text = item.dataString;
    
    [_likeButton setTitle:[NSString stringWithFormat:@"%@",item.likenum]];
    [_likeButton setSelected:[item.taplike isEqual:@2]];
    
}

#pragma mark - Event
- (void)srl_likeButtonAction:(YDSingleRLLikeButton *)sender{
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
            [[YDRootViewController sharedRootViewController] presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    [sender setSelected:!sender.selected];
    NSDictionary *parameter = @{@"d_id":self.item.ub_id,
                                @"access_token":YDAccess_token,
                                @"tl_type":@(self.item.type+1)};
    [YDNetworking POST:kAddLikedynamicURL parameters:parameter success:^(NSNumber *code, NSString *status, id data) {
        YDLog(@"rankingList_tapLike_code = %@",code);
    } failure:^(NSError *error) {
        YDLog(@"rankingList_tapLike_error = %@",error);
    }];
}

#pragma mark - Private Methods
- (void)srl_initSubviews{
    _rankingLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16] textAlignment:NSTextAlignmentCenter];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.cornerRadius = 8.0f;
    _avatarImageView.clipsToBounds = YES;
    
    _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16]];
    
    _locationIcon = [[UIImageView alloc] initWithImage:YDImage(@"dynamic_location_icon")];
    
    _locationLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12]];
    
    _dataLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16] textAlignment:NSTextAlignmentRight];
    
    _likeButton = [[YDSingleRLLikeButton alloc] initWithTitle:@"0" iconPath:@"dynamic_likeButton_normal" iconHLPath:@"dynamic_likeButton_selected"];
    [_likeButton addTarget:self action:@selector(srl_likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self yd_addSubviews:@[_rankingLabel,_avatarImageView,_nameLabel,_locationIcon,_locationLabel,_dataLabel,_likeButton]];
}

- (void)srl_addMasonry{
    
    [_rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.right.equalTo(_avatarImageView.mas_left);
        make.height.mas_equalTo(21);
    }];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(49);
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
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(21, 38));
    }];
    
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_likeButton.mas_left).offset(-20);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
}

@end

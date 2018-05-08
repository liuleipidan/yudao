//
//  YDDynamicLikerCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/4/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDynamicLikerCell.h"
#import "YDDynamicDetailModel.h"

@implementation YDDynamicLikerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _avatarImageV = [[UIImageView alloc] init];
        _nameLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:16];
        _timelabel = [YDUIKit labelTextColor:YDBaseColor fontSize:12 textAlignment:NSTextAlignmentRight];
        _avatarImageV.layer.cornerRadius = 18.0f;
        _avatarImageV.clipsToBounds = YES;
        
        [self.contentView sd_addSubviews:@[_avatarImageV,_nameLabel,_timelabel]];
        
        [_avatarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(36.0f);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageV.mas_right).offset(14);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(22);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        
        [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(200);
        }];
        
    }
    return self;
}

- (void)setModel:(YDTapLikeModel *)model{
    _model = model;
    [_avatarImageV yd_setImageWithString:model.ud_face placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    _nameLabel.text = model.ub_nickname;
    _timelabel.text = model.showTime;
}

@end


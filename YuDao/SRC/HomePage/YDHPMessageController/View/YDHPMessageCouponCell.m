//
//  YDHPMessageCouponCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/29.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDHPMessageCouponCell.h"

@interface YDHPMessageCouponCell()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *lookBtn;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation YDHPMessageCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.moreBtn setImage:[UIImage imageNamed:@"homePage_message_more_gray"] forState:0];
        [self.detailContent yd_addSubviews:@[self.contentLabel,self.lookBtn,self.nameLabel]];
        
        [self y_coupon_addMasonry];
    }
    return self;
}

- (void)setModel:(YDHPMessageModel *)model{
    [super setModel:model];
    
    [_contentLabel setText:model.text lineSpacing:5];
    
    _nameLabel.text = model.coupon_name;
}

- (void)y_coupon_addMasonry{
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(15);
        make.right.equalTo(self.moreBtn.mas_left).offset(5);
        make.height.mas_lessThanOrEqualTo(60);
    }];
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.detailContent);
        make.height.mas_equalTo(36);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentLabel.mas_left);
        make.right.equalTo(self.contentLabel.mas_right);
        make.height.mas_lessThanOrEqualTo(40);
    }];
}

#pragma mark - Getter
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_18]];
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12]];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookBtn setTitle:@"立即查看" forState:0];
        [_lookBtn setTitleColor:[UIColor grayTextColor] forState:0];
        _lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _lookBtn.backgroundColor = [UIColor grayBackgoundColor];
        _lookBtn.enabled = NO;
    }
    return _lookBtn;
}

@end

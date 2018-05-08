//
//  YDSettingCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingCell.h"

@interface YDSettingCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation YDSettingCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.rightImageView];
        [self y_addMasonry];
    }
    return self;
}

- (void) setItem:(YDSettingItem *)item
{
    _item = item;
    [self.titleLabel setText:item.title];
    [self.rightLabel setText:item.subTitle];
    if (item.rightImagePath) {
        [self.rightImageView setImage: [UIImage imageNamed:item.rightImagePath]];
    }
    else if (item.rightImageURL){
        [self.rightImageView sd_setImageWithURL:YDURL(item.rightImageURL) placeholderImage:[UIImage imageNamed:kDefaultAvatarPath]];
    }
    else {
        [self.rightImageView setImage:nil];
    }
    
    if (item.showDisclosureIndicator == NO) {
        [self setAccessoryType: UITableViewCellAccessoryNone];
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_offset(-15.0f);
        }];
    }
    else {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView);
        }];
    }
    
    if (item.disableHighlight) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else {
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
}

#pragma mark - Private Methods
- (void)y_addMasonry{
    [self.titleLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
    }];
    
    [self.rightLabel setContentCompressionResistancePriority:200 forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(20);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightLabel.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Getter
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        [_rightLabel setTextColor:[UIColor grayColor]];
        [_rightLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    return _rightLabel;
}

- (UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

@end

//
//  YDSettingSwitchCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingSwitchCell.h"

@interface YDSettingSwitchCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UISwitch *cellSwitch;

@end

@implementation YDSettingSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.openDelegate = YES;
        [self setAccessoryView:self.cellSwitch];
        [self.contentView addSubview:self.titleLabel];
        [self y_addMasonry];
    }
    return self;
}

- (void)setItem:(YDSettingItem *)item{
    _item = item;
    self.cellSwitch.on = item.switchStatus;
    [self.titleLabel setText:item.title];
}

#pragma mark - Event Response -
- (void)switchChangeStatus:(UISwitch *)sender{
    
    if (self.openDelegate && _delegate && [_delegate respondsToSelector:@selector(settingSwitchCell:item:switchBtn:)]) {
        [_delegate settingSwitchCell:self item:self.item switchBtn:sender];
    }
}

#pragma mark - Private Methods -
- (void)y_addMasonry
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-15);
    }];
}

#pragma mark - Getter -
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UISwitch *)cellSwitch{
    if (_cellSwitch == nil) {
        _cellSwitch = [[UISwitch alloc] init];
        [_cellSwitch addTarget:self action:@selector(switchChangeStatus:) forControlEvents:UIControlEventValueChanged];
    }
    return _cellSwitch;
}

@end

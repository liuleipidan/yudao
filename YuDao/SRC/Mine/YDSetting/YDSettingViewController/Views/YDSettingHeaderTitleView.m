//
//  YDSettingHeaderTitleView.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingHeaderTitleView.h"

@implementation YDSettingHeaderTitleView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-5.0f);
        }];
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.titleLabel.text = text;
}

#pragma mark - Getter
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setFont:[UIFont fontSettingHeaderAndFooterTitle]];
        [_titleLabel setNumberOfLines:0];
    }
    return _titleLabel;
}

@end

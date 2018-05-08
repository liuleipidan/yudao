//
//  YDSettingFooterTitleView.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingFooterTitleView.h"

@implementation YDSettingFooterTitleView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
            make.top.mas_equalTo(self.contentView).mas_offset(5.0f);
        }];
    }
    return self;
}

@end

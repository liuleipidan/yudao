//
//  YDMoreKeyboardCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMoreKeyboardCell.h"

@interface YDMoreKeyboardCell()

@property (nonatomic, strong) UIButton *iconBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YDMoreKeyboardCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconBtn];
        [self y_addMasonry];
    }
    return self;
}

- (void)y_addMasonry{
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.width.equalTo(self.contentView);
        make.height.equalTo(_iconBtn.mas_width);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.contentView);
    }];
}

- (void)setItem:(YDMoreKeyboardItem *)item{
    _item = item;
    if (item == nil) {
        self.titleLabel.hidden = YES;
        self.iconBtn.hidden = YES;
        self.userInteractionEnabled = NO;
        return;
    }
    self.userInteractionEnabled = YES;
    self.titleLabel.hidden = NO;
    self.iconBtn.hidden = NO;
    self.titleLabel.text = item.title;
    [self.iconBtn setImage:YDImage(item.imagePath) forState:UIControlStateNormal];
}

- (void)iconBtnAction:(UIButton *)sender{
    if (self.clickBlock) {
        self.clickBlock(self.item);
    }
}

- (UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorGrayLine]] forState:UIControlStateHighlighted];
        [_iconBtn addTarget:self action:@selector(iconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
    }
    return _titleLabel;
}


@end

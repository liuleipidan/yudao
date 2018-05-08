//
//  YDPopDownCell.m
//  YuDao
//
//  Created by 汪杰 on 16/12/1.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDPopDownCell.h"

@interface YDPopDownCell()

@property (nonatomic, strong) UIButton *iconBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YDPopDownCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor blackTextColor]];
        UIView *selectedView = [[UIView alloc] init];
        [selectedView setBackgroundColor:[UIColor colorBlackForAddMenuHL]];
        [self setSelectedBackgroundView:selectedView];
        
        [self.contentView addSubview:self.iconBtn];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        
        [self p_addMasonry];
    }
    return self;
}

- (void)setItem:(YDAddMenuItem *)item{
    _item = item;
    [self.iconBtn setImage:item.iconPath imageHL:item.iconPath];
    self.titleLabel.text = item.title;
}

- (void)setHideSeperatorLine:(BOOL)hideSeperatorLine{
    _hideSeperatorLine = hideSeperatorLine;
    self.lineView.hidden = hideSeperatorLine;
}

#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(15.0f);
        make.centerY.mas_equalTo(self);
        make.height.and.width.mas_equalTo(32);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconBtn.mas_right).mas_offset(10.0f);
        make.centerY.mas_equalTo(self.iconBtn);
    }];
    [self. lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Getter
- (UIButton *)iconBtn{
    if (_iconBtn == nil) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _iconBtn;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = YDColor(255, 255, 255, 0.2);
    }
    return _lineView;
}

@end

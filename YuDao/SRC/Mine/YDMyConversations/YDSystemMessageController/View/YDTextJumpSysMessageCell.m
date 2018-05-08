//
//  YDAuthFailureSysMessageCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTextJumpSysMessageCell.h"

@interface YDTextJumpSysMessageCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *lookLabel;

@end

@implementation YDTextJumpSysMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.borderView yd_addSubviews:@[self.titleLabel,self.contentLabel,self.lookLabel]];
        
        [self af_addMasonry];
    }
    return self;
}

- (void)setMessage:(YDSystemMessage *)message{
    [super setMessage:message];
    
    _titleLabel.text = message.title;
    _contentLabel.text = message.text;
    _lookLabel.text = message.jumpText;
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(message.textHeight);
    }];
}

- (void)af_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderView).offset(15);
        make.top.equalTo(self.borderView).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 50);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.right.equalTo(self.borderView).offset(-15);
    }];
    
    [_lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.borderView).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(80);
    }];
}

#pragma mark - Event
- (void)sm_didClickedLookLabel:(UIGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(systemMessage:didClickedLookLabel:)]) {
        [self.delegate systemMessage:self.message didClickedLookLabel:(UILabel *)tap.view];
    }
}

#pragma mark - Getters
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16]];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14]];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)lookLabel{
    if (_lookLabel == nil) {
        _lookLabel = [UILabel labelByTextColor:[UIColor orangeTextColor] font:[UIFont font_14]];
        _lookLabel.text = @"重新提交>>";
        _lookLabel.userInteractionEnabled = YES;
        [_lookLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sm_didClickedLookLabel:)]];
    }
    return _lookLabel;
}


@end

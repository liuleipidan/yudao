//
//  YDCarInfoTextFieldCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/17.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarInfoTextFieldCell.h"
#import "YDLimitTextField.h"

@interface YDCarInfoTextFieldCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) YDLimitTextField *textField;

@end

@implementation YDCarInfoTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self tf_initSubviews];
        [self tf_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setItem:(YDCarInfoItem *)item{
    _item = item;
    
    _titleLabel.text = item.title;
    
    _textField.placeholder = item.placeholder;
    _textField.text = item.subTitle.length > 0 ? item.subTitle : @"";
    _textField.limit = 0;
}

#pragma mark - Private Methods
- (void)tf_initSubviews{
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    _textField = [[YDLimitTextField alloc] initWithLimit:50];
    _textField.textColor = [UIColor grayTextColor];
    YDWeakSelf(self);
    [_textField setTextDidChangeBlock:^(NSString *text) {
        weakself.item.subTitle = text;
    }];
    
    [self.contentView yd_addSubviews:@[_titleLabel,_textField]];
}

- (void)tf_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(140);
        make.height.mas_equalTo(22);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}

@end

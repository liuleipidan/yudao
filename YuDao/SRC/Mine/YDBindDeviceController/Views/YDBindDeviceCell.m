//
//  YDBindDeviceCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDBindDeviceCell.h"
#import "YDLimitTextField.h"

@interface YDBindDeviceCell()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) YDLimitTextField *textField;

@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation YDBindDeviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self bd_initSubviews];
        [self bd_addMasonry];
        
    }
    return self;
}

- (void)setItem:(YDBindDevice *)item{
    _item = item;
    
    _titleLabel.text = item.title;
    
    _textField.placeholder = item.placeholder;
    _textField.text = item.subTitle;
    _textField.limit = item.textFieldLimit;
    
    if (item.type == YDBindDeviceCellTypeArrow) {
        _textField.enabled = NO;
        [_rightButton setImage:YDImage(item.rightImagePath) forState:0];
        _rightButton.userInteractionEnabled = NO;
    }
    else if (item.type == YDBindDeviceCellTypeScanner){
        [_rightButton setImage:YDImage(item.rightImagePath) forState:0];
        _rightButton.userInteractionEnabled = YES;
    }
    else{
        _rightButton.userInteractionEnabled = NO;
        [_rightButton setImage:nil forState:0];
    }
    
    
}

#pragma mark  - Events
- (void)bd_rightButtonAction:(UIButton *)sender{
    if (self.item.type == YDBindDeviceCellTypeScanner
        && self.delegate
        && [self.delegate respondsToSelector:@selector(bindDeviceCell:didTouchScannerButton:)]) {
        [self.delegate bindDeviceCell:self didTouchScannerButton:sender];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

#pragma mark - Private Methods
- (void)bd_initSubviews{
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    
    _textField = [[YDLimitTextField alloc] init];
    _textField.textColor = [UIColor grayTextColor];
    _textField.font = [UIFont font_14];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    YDWeakSelf(self);
    [_textField setTextDidChangeBlock:^(NSString *text) {
        if (weakself.item.type != YDBindDeviceCellTypeArrow) {
            weakself.item.subTitle = text;
        }
        if ((weakself.item.type == YDBindDeviceCellTypeNone
            || weakself.item.type == YDBindDeviceCellTypeScanner)
            && weakself.delegate
            && [weakself.delegate respondsToSelector:@selector(bindDeviceCell:textFieldTextDidChange:)]) {
            [weakself.delegate bindDeviceCell:weakself textFieldTextDidChange:text];
        }
    }];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton addTarget:self action:@selector(bd_rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView yd_addSubviews:@[_titleLabel,_textField,_rightButton]];
}

- (void)bd_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(60);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kWidth(140));
        make.height.mas_equalTo(20);
        make.right.equalTo(_rightButton.mas_left).offset(-5);
    }];
}

@end

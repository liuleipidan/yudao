//
//  YDMyInfoInputCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMyTextFieldCell.h"

@interface YDMyTextFieldCell()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) YDLimitTextField *textField;

@end

@implementation YDMyTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self mic_initSubviews];
        [self mic_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setItem:(YDMyInfoItem *)item{
    _item = item;
    
    _titleLabel.text = item.title;
    _textField.text = item.subTitle;
    _textField.placeholder = item.placeholder;
    [_textField setLimit:item.limit];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([[YDUserDefault defaultUser].user.ud_userauth isEqual:@1] && [self.item.title isEqualToString:@"真实姓名"]) {
        [YDMBPTool showInfoImageWithMessage:@"已认证不可修改" hideBlock:^{
            
        }];
        return NO;
    }else if([[YDUserDefault defaultUser].user.ud_userauth isEqual:@2] && [self.item.title isEqualToString:@"真实姓名"]){
        [YDMBPTool showInfoImageWithMessage:@"认证中不可修改" hideBlock:nil];
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods
- (void)mic_initSubviews{
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    
    _textField = [[YDLimitTextField alloc] init];
    _textField.textColor = [UIColor grayTextColor];
    _textField.delegate = self;
    YDWeakSelf(self);
    [_textField setTextDidChangeBlock:^(NSString *text){
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(myTextFieldCell:textDidChanged:)]) {
            weakself.item.subTitle = weakself.textField.text;
            [weakself.delegate myTextFieldCell:weakself textDidChanged:weakself.item.subTitle];
        }
    }];
    
    [self.contentView yd_addSubviews:@[_titleLabel,_textField]];
}

- (void)mic_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(152));
        make.right.equalTo(self.contentView).offset(-42);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(self.contentView);
    }];
    
}

@end

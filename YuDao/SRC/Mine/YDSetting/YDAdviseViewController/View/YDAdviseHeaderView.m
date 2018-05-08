//
//  YDAdviseHeaderView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDAdviseHeaderView.h"

#define kAdviseLestLength 20
#define kAdviseMostLength 500

@interface YDAdviseHeaderView()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) UILabel *stringLengthLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIView *leftLine;

@property (nonatomic, strong) UIView *rightLine;

@end

@implementation YDAdviseHeaderView

@synthesize text = _text;

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor grayBackgoundColor];
        
        [self ah_initSubviews];
        [self ah_addMasonry];
        
    }
    return self;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeHolderLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    if (text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
    else{
        self.placeHolderLabel.hidden = NO;
    }
    
    self.stringLengthLabel.text = [NSString stringWithFormat:@"%lu/%d",text.length,kAdviseMostLength];
    //字数限制操作
    if (text.length >= kAdviseMostLength) {
        
        textView.text = [text substringToIndex:kAdviseMostLength];
        self.stringLengthLabel.text = [NSString stringWithFormat:@"%d/%d",kAdviseMostLength,kAdviseMostLength];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods
- (void)ah_commitButtonAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(adviseHeaderView:didClickedCommitButton:)]) {
        [_delegate adviseHeaderView:self didClickedCommitButton:sender];
    }
}

- (void)ah_initSubviews{
    
    [self yd_addSubviews:@[self.textView,self.commitBtn,self.stringLengthLabel,self.bottomLabel,self.leftLine,self.rightLine]];
    [self.textView addSubview:self.placeHolderLabel];
}

- (void)ah_addMasonry{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.48);
    }];
    
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_textView).offset(5);
        make.size.mas_equalTo(CGSizeMake(150, 21));
    }];
    
    [_stringLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(_textView.mas_bottom).offset(-10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(17);
    }];
    
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(309), kHeight(44)));
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_commitBtn);
        make.top.equalTo(_commitBtn.mas_bottom).offset(40);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(85);
    }];

    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(_bottomLabel);
        make.right.equalTo(_bottomLabel.mas_left).offset(-20).priorityLow();
        make.height.mas_equalTo(1);
    }];

    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomLabel.mas_right).offset(20).priorityLow();
        make.centerY.equalTo(_bottomLabel);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(1);
    }];
}

- (void)setText:(NSString *)text{
    _text = text;
    self.textView.text = text;
}
#pragma mark - Getter
- (NSString *)text{
    return self.textView.text;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.backgroundColor = [UIColor baseColor];
        _commitBtn.layer.cornerRadius = 8.0f;
        [_commitBtn setTitle:@"提交" forState:0];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_commitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_commitBtn addTarget:self action:@selector(ah_commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_16]];
        _placeHolderLabel.text = @"请提交您宝贵的意见";
    }
    return _placeHolderLabel;
}

- (UILabel *)stringLengthLabel{
    if (!_stringLengthLabel) {
        _stringLengthLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentRight];
        _stringLengthLabel.text = [NSString stringWithFormat:@"0/%d",kAdviseMostLength];
    }
    return _stringLengthLabel;
}

- (UILabel *)bottomLabel{
    if (_bottomLabel == nil) {
        _bottomLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_16] textAlignment:NSTextAlignmentCenter];
        _bottomLabel.text = @"意见留言板";
    }
    return _bottomLabel;
}

- (UIView *)leftLine{
    if (_leftLine == nil) {
        _leftLine = [UIView new];
        _leftLine.backgroundColor = [UIColor shadowColor];
    }
    return _leftLine;
}

- (UIView *)rightLine{
    if (_rightLine == nil) {
        _rightLine = [UIView new];
        _rightLine.backgroundColor = [UIColor shadowColor];
    }
    return _rightLine;
}

@end

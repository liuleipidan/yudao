//
//  YDLoginInputView.m
//  YuDao
//
//  Created by 汪杰 on 16/11/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDLoginInputView.h"
#import "YDLoginViewController.h"
#import "YDRegisterController.h"

@interface YDLoginInputView()



@end

@implementation YDLoginInputView
{
    NSTimer *_timer;
    NSInteger _time;
}

- (instancetype)initWithType:(YDLoginInputViewType )type subType:(YDLoginInputViewSubType )subType{
    if(self = [super init]){
        self.type = type;
        self.subType = subType;
        UIView *lineView = [YDUIKit viewWithBackgroundColor:YDBaseColor];
        [self sd_addSubviews:@[lineView,self.label,self.textF,self.variableBtn,self.icon]];
        [self y_layoutSubviews];
        
        if (self.subType == YDLoginInputViewSubTypePhone) {
            self.variableBtn.hidden = YES;
            _textF.placeholder = @"请输入手机号";
        }else{
            _textF.placeholder = @"请输入验证码";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneNumberDidChange:) name:kPhoneNumberNotification object:nil];
        }
        
        lineView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self)
        .heightIs(1);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelTextFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.textF];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)phoneNumberDidChange:(NSNotification *)noti{
    self.phoneNumber = noti.object;
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.label.text = [dataDic valueForKey:@"label"];
    
    [_icon setImage:[UIImage imageNamed:[dataDic valueForKey:@"image"]] forState:0];
}

- (void)y_layoutSubviews{
    _label.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self,10)
    .heightIs(21);
    [self.label setSingleLineAutoResizeWithMaxWidth:60];
    
    _variableBtn.sd_layout
    .centerYEqualToView(self)
    .rightEqualToView(self)
    .heightIs(26)
    .widthIs(87);
    
    _icon.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self,6)
    .widthIs(19)
    .heightIs(19);
    
    UIView *lineView = [YDUIKit viewWithBackgroundColor:YDBaseColor];
    [self addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(_icon,14)
    .centerYEqualToView(self)
    .widthIs(1)
    .heightIs(15);
    
    self.textF.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(lineView,14)
    .rightSpaceToView(self,0)
    .heightRatioToView(self,1);
}

//MARK:监听标签栏的字数
- (void)labelTextFiledEditChanged:(NSNotification *)obj
{
    NSInteger length = 0;
    if ([self.label.text isEqualToString:@"帐号"]) {
        length = 11;
    }else{
        length = 4;
    }
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if (toBeString.length == length) {
        [textField resignFirstResponder];
    }
    if ([lang isEqualToString:@"zh-Hans"]){// 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){
            if (toBeString.length > length)
            {
                textField.text = [toBeString substringToIndex:length];
            }
        }
    }
    else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > length){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
            if (rangeIndex.length == 1){
                textField.text = [toBeString substringToIndex:length];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
            
        }
    }
    if (self.subType == YDLoginInputViewSubTypePhone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPhoneNumberNotification object:textField.text];
    }
}

//MARK:Getters
- (UILabel *)label{
    if (!_label) {
        _label = [YDUIKit labelTextColor:[UIColor whiteColor] fontSize:kFontSize(17)];
        _label.hidden = YES;
    }
    return _label;
}

- (UIButton *)icon{
    if (!_icon) {
        _icon = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _icon;
}


- (UITextField *)textF{
    if (!_textF) {
        _textF = [UITextField new];
        _textF.keyboardType = UIKeyboardTypeNumberPad;
        _textF.delegate = self;
        _textF.textColor = YDBaseColor;
        [_textF setFont:[UIFont font_16]];
    }
    return _textF;
}

- (UIButton *)variableBtn{
    if (!_variableBtn) {
        _variableBtn = [UIButton new];
        [_variableBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_variableBtn setBackgroundColor:YDBaseColor];
        [_variableBtn setTitle:@"获取验证码" forState:0];
        [_variableBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _variableBtn.layer.cornerRadius = 8.0f;
        [_variableBtn addTarget:self action:@selector(variableBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _variableBtn;
}

- (void)variableBtnAction:(UIButton *)sender{
    if (self.phoneNumber.length < 11 && self.subType == YDLoginInputViewSubTypePassword) {
        [YDMBPTool showInfoImageWithMessage:@"手机号输入错误" hideBlock:nil];
        return;
    }
    
    [sender setTitle:@"获取中..." forState:0];
    sender.enabled = NO;
    
    [YDNetworking GET:kSmsURL parameters:@{@"ub_cellphone":YDNoNilString(self.phoneNumber), @"type":YDNoNilNumber(@(self.type))} success:^(NSNumber *code, NSString *status, id data) {
        if ([code isEqual:@4005]) {//手机号未注册
            [sender setTitle:@"获取动态密码" forState:0];
            sender.enabled = YES;
            [YDMBPTool showInfoImageWithMessage:@"手机号未注册" hideBlock:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginInputView:didSelectedVariableBtnWithBackCode:)]) {
                    [self.delegate loginInputView:self didSelectedVariableBtnWithBackCode:code];
                }
            }];
        }
        else if ([code isEqual:@4003]){//手机号已注册
            [sender setTitle:@"获取动态密码" forState:0];
            sender.enabled = YES;
            [YDMBPTool showInfoImageWithMessage:@"手机号已注册" hideBlock:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginInputView:didSelectedVariableBtnWithBackCode:)]) {
                    [self.delegate loginInputView:self didSelectedVariableBtnWithBackCode:code];
                }
            }];
        }
        else if ([code isEqual:@4004]) {//验证码超限
            [YDMBPTool showInfoImageWithMessage:@"验证码获取次数过多" hideBlock:nil];
            [sender setTitle:@"获取动态密码" forState:0];
            sender.enabled = YES;
        }else if ([code isEqual:@200]){//成功
            sender.backgroundColor = YDColorString(@"#C7C7CC");
            _time = 59;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lgTimerAction:) userInfo:nil repeats:YES];
            [YDMBPTool showText:@"验证码正火速赶往中..."];
        }
    } failure:^(NSError *error) {
        [YDMBPTool showErrorImageWithMessage:@"获取失败，请检查网络或手机号" hideBlock:nil];
        [sender setTitle:@"获取动态密码" forState:0];
        sender.enabled = YES;
    }];
    
}

- (void)lgTimerAction:(id)sender{
    _time -= 1;
    [self.variableBtn setTitle:[NSString stringWithFormat:@"%ldS",(long)_time] forState:0];
    if (_time == 0) {
        [self.variableBtn setTitle:@"获取动态密码" forState:0];
        self.variableBtn.enabled = YES;
        self.variableBtn.backgroundColor = YDBaseColor;
        [_timer invalidate];
        _timer = nil;
    }
}


@end

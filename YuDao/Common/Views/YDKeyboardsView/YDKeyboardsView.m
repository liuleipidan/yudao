//
//  YDKeyboardsView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/29.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDKeyboardsView.h"
#import "YDEmojiKeyboard.h"
#import "YDEmojiKBHelper.h"

static CGFloat const kToolViewHeight = 42.f;

@interface YDKeyboardsView()<YDEmojiKeyboardDelegate>

@property (nonatomic, strong) UIView *toolView;

@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, strong) YDEmojiKeyboard *emojiKeyboard;

@property (nonatomic, strong) UIView *keyboardContentView;

@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, weak) UIView *inputedView;

@end

@implementation YDKeyboardsView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor searchBarBackgroundColor];
        
        [self addSystemKeyboardNotifications];
        
        [self yd_addSubviews:@[self.toolView,self.keyboardContentView,self.emojiButton]];
        
        [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(kToolViewHeight);
        }];
        
        [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_toolView);
            make.left.equalTo(_toolView.mas_left).offset(20);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.keyboardContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.toolView.mas_bottom);
        }];
        
        _status = YDKeyboardsViewStatusInit;
        
    }
    return self;
}

- (void)dealloc{
    [YDNotificationCenter removeObserver:self];
}

- (void)showWillInView:(UIView *)view inputedView:(UIView *)inputedView{
    if (_isShow || inputedView == nil) {
        return;
    }
    
    view = view == nil ? view: [UIApplication sharedApplication].keyWindow;
    
    _isShow = YES;
    _status = YDKeyboardsViewStatusSystem;
    _inputedView = inputedView;
    
    [view addSubview:self];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.mas_equalTo(kToolViewHeight);
        make.bottom.equalTo(view).mas_offset(kToolViewHeight);
    }];
    
    [self layoutIfNeeded];
}

- (void)dismiss{
    _isShow = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_keyboardHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
/**
 点击表情
 */
- (void)emojiKeyboard:(YDEmojiKeyboard *)emojiKB didSelectedEmojiItem:(YDEmoji *)emoji{
    if ([_inputedView isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)_inputedView;
        textView.text = [textView.text stringByAppendingString:emoji.emojiName];
    }
    else if ([_inputedView isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)_inputedView;
        textField.text = [textField.text stringByAppendingString:emoji.emojiName];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(emojiKeyboard:didSelectedEmojiItem:)]) {
        [_delegate emojiKeyboard:emojiKB didSelectedEmojiItem:emoji];
    }
}

/**
 点击发送
 */
- (void)emojiKeyboardSendButtonDown{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiKeyboardSendButtonDown)]) {
        [_delegate emojiKeyboardSendButtonDown];
    }
}

/**
 点击删除
 */
- (void)emojiKeyboardDeleteButtonDown{
    if ([_inputedView isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)_inputedView;
        [NSString deleteEmojiString:textView.text completoin:^(BOOL ok, NSString *text) {
            NSLog(@"ok = %d, text = %@",ok,text);
            textView.text = text;
        }];
    }
    else if ([_inputedView isKindOfClass:[UITextField class]]){
//        UITextField *textField = (UITextField *)_inputedView;
//        textField.text = [textField.text stringByAppendingString:emoji.emojiName];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(emojiKeyboardDeleteButtonDown)]) {
        [_delegate emojiKeyboardDeleteButtonDown];
    }
}

#pragma mark - Notifications
- (void)addSystemKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    _status = YDKeyboardsViewStatusSystem;
}

- (void)keyboardDidShow:(NSNotification *)notification{
    NSLog(@"%s",__func__);
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSLog(@"%s _status = %ld",__func__,_status);
    if (_status == YDKeyboardsViewStatusEmoji) {
        return;
    }
    
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat sysKeyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height + kToolViewHeight;
    
    if (_keyboardHeight <= sysKeyboardHeight) {
        _keyboardHeight = sysKeyboardHeight;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_keyboardHeight);
            make.bottom.equalTo(self.superview).offset(_keyboardHeight);
        }];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:duration > 0 ? duration : 0.1 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.superview);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    if (_status == YDKeyboardsViewStatusEmoji) {
        return;
    }
    [self dismiss];
}


#pragma mark - Events
- (void)emojiButtonDown:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (_status == YDKeyboardsViewStatusEmoji) {
        _status = YDKeyboardsViewStatusSystem;
        
        [self.emojiKeyboard dismissWithAnimation:YES];
        
        if (_inputedView) {
            [_inputedView becomeFirstResponder];
        }
        
    }
    else if (_status == YDKeyboardsViewStatusSystem){
        _status = YDKeyboardsViewStatusEmoji;
        if (_inputedView) {
            [_inputedView resignFirstResponder];
        }
        [self.emojiKeyboard showInView:self withAnimation:YES];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([self.emojiKeyboard keyboardHeight] + kToolViewHeight);
        }];
        [self layoutIfNeeded];
    }
    else{
        _status = YDKeyboardsViewStatusInit;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(keyboardsView:statusDidChange:)]) {
        [_delegate keyboardsView:self statusDidChange:_status];
    }
    
}

#pragma mark - YDEmojiKeyboardDelegate

#pragma mark - Getters
- (UIView *)toolView{
    if (_toolView == nil) {
        _toolView = [UIView new];
        _toolView.backgroundColor = [UIColor redColor];
    }
    return _toolView;
}

- (UIView *)keyboardContentView{
    if (_keyboardContentView == nil) {
        _keyboardContentView = [UIView new];
        _keyboardContentView.backgroundColor = [UIColor greenColor];
    }
    return _keyboardContentView;
}

- (UIButton *)emojiButton{
    if (_emojiButton == nil) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiButton setImage:@"chat_toolbar_emoji" imageSelected:@"chat_toolbar_keyboard"];
        [_emojiButton addTarget:self action:@selector(emojiButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (YDEmojiKeyboard *)emojiKeyboard{
    if (_emojiKeyboard == nil) {
        _emojiKeyboard = [[YDEmojiKeyboard alloc] init];
        _emojiKeyboard.delegate = self;
        [self.emojiKeyboard setEmojiGroupData:[YDEmojiKBHelper sharedInstance].emojiGroupData];
    }
    return _emojiKeyboard;
}

@end

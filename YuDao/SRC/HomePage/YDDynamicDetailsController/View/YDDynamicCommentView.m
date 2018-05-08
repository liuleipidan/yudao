//
//  YDDynamicCommentView.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/10.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDynamicCommentView.h"
#import "YDEmojiKeyboard.h"
#import "YDEmojiKBHelper.h"

@interface YDDynamicCommentView ()<UITextViewDelegate,YDKeyboardDelegate,YDEmojiKeyboardDelegate>

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, strong) YDEmojiKeyboard *emojiKeyboard;

@property (nonatomic, assign) YDKeyboardControlStatus status;

@property (nonatomic, strong) UILabel *placeholderLabel;

@end


@implementation YDDynamicCommentView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self dc_initSubviews];
        [self dc_addMasonry];
        [self dc_addKeyboardNotifications];
        
        
        [YDNotificationCenter addObserver:self selector:@selector(dc_textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
        
        [self setPlaceholderText:@"评论"];
    }
    return self;
}

- (void)dealloc{
    [YDNotificationCenter removeObserver:self];
    NSLog(@"%s",__func__);
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *testView = [super hitTest:point withEvent:event];
//    NSLog(@"testView = %@",testView);
//    if (testView != self || testView != _whiteView) {
//        return testView;
//    }
//    return nil;
//}

#pragma mark - Public Methods
- (void)show{
    [self showInView:nil];
}

- (void)showInView:(UIView *)view{
    if (self.superview) {
        [self removeFromSuperview];
    }
    _status = YDKeyboardControlStatusInit;
    _sendButton.enabled = NO;
    if (view) {
        [view addSubview:self];
        [_textView becomeFirstResponder];
    }
    else{
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
            for (UIWindow *window in frontToBackWindows)
            {
                BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
                BOOL windowIsVisible = !window.hidden && window.alpha > 0;
                BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
                
                if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
                {
                    [window addSubview:self];
                    break;
                }
            }
            
            [_textView becomeFirstResponder];
        }];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(dynamicCommentViewWillShow:)]) {
        [_delegate dynamicCommentViewWillShow:self];
    }
}

- (void)dismiss{
    if (_delegate && [_delegate respondsToSelector:@selector(dynamicCommentViewWillHide:)]) {
        [_delegate dynamicCommentViewWillHide:self];
    }
    if (_status == YDKeyboardControlStatusSystem) {
        [_textView resignFirstResponder];
    }
    else if (_status == YDKeyboardControlStatusEmoji){
        [self.emojiKeyboard dismissWithAnimation:YES];
        [UIView animateWithDuration:0.25 animations:^{
            _backgroundView.alpha = 0;
            [_whiteView setY:self.height];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)setPlaceholderText:(NSString *)placeholderText{
    
    _placeholderText = placeholderText;
    
    if (placeholderText.length > 0) {
        _placeholderLabel.text = placeholderText;
        _textView.text = @"";
    }
    else{
        _placeholderLabel.text = @"评论";
    }
}

#pragma mark - UITextViewDelegate

#pragma mark - Events
- (void)dc_cancelButtonAction:(UIButton *)sender{
    [self dismiss];
}

- (void)dc_sendButtonAction:(UIButton *)sender{
    [self dismiss];
    [self dc_sendText];
}

- (void)dc_emojiButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    _status = sender.isSelected ? YDKeyboardControlStatusEmoji : YDKeyboardControlStatusSystem;
    
    if (_status == YDKeyboardControlStatusEmoji) {
        if (self.textView.isFirstResponder) {
            [self.textView resignFirstResponder];
        }
        [self.emojiKeyboard showInView:self withAnimation:YES];
    }
    else if (_status == YDKeyboardControlStatusSystem){
        [self.emojiKeyboard dismissWithAnimation:YES];
        if (!self.textView.isFirstResponder) {
            [self.textView becomeFirstResponder];
        }
    }
    
}

- (void)dc_didTapBackgroundView:(UITapGestureRecognizer *)tap{
    NSLog(@"%s",__func__);
    //[self dismiss];
}

- (void)dc_textViewTextDidChange:(NSNotification *)noti{
    if (noti.object == self.textView) {
        self.placeholderLabel.hidden = self.textView.text.length > 0 ? YES : NO;
        self.sendButton.enabled = self.textView.text.length > 0 ? YES : NO;
        
        CGFloat textHeight = [self.textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)].height;
        if (textHeight > self.textView.height) {
            [self.textView setContentOffset:CGPointMake(0, textHeight - self.textView.height) animated:YES];
        }
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self dc_sendButtonAction:self.sendButton];
        return NO;
    }
    if (textView.text.length > 0 && [text isEqualToString:@""]) {       // delete
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            while (location != 0) {
                location --;
                length ++ ;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    return NO;
                }
                else if (c == ']') {
                    return YES;
                }
            }
        }
    }
    
    return YES;
}

#pragma mark - YDKeyboardDelegate
- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height{
    
    if (height <= 0 || !self.emojiKeyboard.isShow) {
        return;
    }
    [_whiteView setY:(self.height - height - _whiteView.height)];
}

#pragma mark - YDEmojiKeyboardDelegate
/**
 点击表情
 */
- (void)emojiKeyboard:(YDEmojiKeyboard *)emojiKB didSelectedEmojiItem:(YDEmoji *)emoji{
    _textView.text = [_textView.text stringByAppendingFormat:@"%@",emoji.emojiName];
    [YDNotificationCenter postNotificationName:UITextViewTextDidChangeNotification object:_textView];
}

/**
 点击发送
 */
- (void)emojiKeyboardSendButtonDown{
    [self dismiss];
    [self dc_sendText];
}

/**
 点击删除
 */
- (void)emojiKeyboardDeleteButtonDown{
    if([self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length - 1, 1) replacementText:@""]){
        [self.textView deleteBackward];
        [YDNotificationCenter postNotificationName:UITextViewTextDidChangeNotification object:_textView];
    }
}

#pragma mark - Keyboard Notifications
- (void)dc_addKeyboardNotifications{
    [YDNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [YDNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [YDNotificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [YDNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    self.status = YDKeyboardControlStatusSystem;
    if (_backgroundView.alpha == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _backgroundView.alpha = 0.4f;
        }];
    }
}

- (void)keyboardDidShow:(NSNotification *)noti{
    
}

- (void)keyboardFrameWillChange:(NSNotification *)noti{
    if (self.status == YDKeyboardControlStatusEmoji) {
        return;
    }
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        [_whiteView setY:keyboardFrame.origin.y - _whiteView.height];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti{
    if (self.status == YDKeyboardControlStatusEmoji) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _backgroundView.alpha = 0;
        [_whiteView setY:self.height];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

#pragma mark - Private Methods
- (void)dc_sendText{
    
    if (_delegate && [_delegate respondsToSelector:@selector(dynamicCommentView:didClickedSendWithText:)]) {
        [_delegate dynamicCommentView:self didClickedSendWithText:self.textView.text];
    }
    self.textView.text = @"";
}

- (void)dc_initSubviews{
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    
    _whiteView = [UIView new];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_whiteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dc_didTapBackgroundView:)]];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setImage:@"dynamic_button_cancel" imageHL:@"dynamic_button_cancel"];
    [_cancelButton addTarget:self action:@selector(dc_cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setImage:@"dynamic_button_sender" imageHL:@"dynamic_button_sender"];
    [_sendButton addTarget:self action:@selector(dc_sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emojiButton setImage:@"chat_toolbar_emoji" imageSelected:@"chat_toolbar_keyboard"];
    [_emojiButton addTarget:self action:@selector(dc_emojiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _textView = [UITextView new];
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont font_16];
    _textView.textColor = [UIColor blackTextColor];
    
    _placeholderLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_16]];
    
    [self yd_addSubviews:@[_backgroundView,_whiteView]];
    [_whiteView yd_addSubviews:@[_textView,_cancelButton,_sendButton,_emojiButton,_placeholderLabel]];
}

- (void)dc_addMasonry{
//    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
    [_backgroundView setFrame:self.bounds];
    [_whiteView setFrame:CGRectMake(0, self.height, self.width, 180)];
    
//    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self);
//        make.height.mas_equalTo(180);
//    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_whiteView).offset(5);
        make.top.equalTo(_whiteView).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cancelButton);
        make.right.equalTo(_whiteView).offset(-5);
        make.width.height.mas_equalTo(40);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_whiteView).offset(15);
        make.right.equalTo(_whiteView).offset(-15);
        make.top.equalTo(_whiteView).offset(49);
        make.bottom.equalTo(_emojiButton.mas_top).offset(-10);
    }];
    
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textView.mas_left).offset(5);
        make.top.equalTo(_textView.mas_top).offset(5);
        make.height.mas_equalTo(21);
        make.right.equalTo(_textView.mas_right).offset(-5);
    }];
    
    [_emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_whiteView).offset(15);
        make.bottom.equalTo(_whiteView).offset(-10);
        make.width.height.mas_equalTo(28);
    }];
}


#pragma mark - Getter
- (YDEmojiKeyboard *)emojiKeyboard{
    if (_emojiKeyboard == nil) {
        _emojiKeyboard = [[YDEmojiKeyboard alloc] init];
        _emojiKeyboard.keyboardDelegate = self;
        _emojiKeyboard.delegate = self;
        [_emojiKeyboard setDoneButtonTitle:@"发送"];
        [_emojiKeyboard setEmojiGroupData:[YDEmojiKBHelper sharedInstance].emojiGroupData];
    }
    return _emojiKeyboard;
}

@end

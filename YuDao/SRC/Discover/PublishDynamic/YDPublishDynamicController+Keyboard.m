//
//  YDPublishDynamicController+Keyboard.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPublishDynamicController+Keyboard.h"

@implementation YDPublishDynamicController (Keyboard)

- (void)addKeyboardNotifications{
    [YDNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [YDNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [YDNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [YDNotificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - YDKeyboardControlDelegate
- (void)keyboardControl:(YDKeyboardControl *)control didDidChangeStatus:(YDKeyboardControlStatus )status{
    
    if (status == YDKeyboardControlStatusInit) {
        return;
    }
    if (status == YDKeyboardControlStatusEmoji) {
        if (self.inputingView.isFirstResponder) {
            [self.inputingView resignFirstResponder];
        }
        
        [self.emojiKeyboard showInView:self.view withAnimation:YES];
    }
    else if (status == YDKeyboardControlStatusSystem){
        [self.emojiKeyboard dismissWithAnimation:YES];
        if (!self.inputingView.isFirstResponder) {
            [self.inputingView becomeFirstResponder];
        }
    }
}

#pragma mark - YDKeyboardDelegate
- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height{
    
    if (height <= 0 || !self.emojiKeyboard.isShow) {
        return;
    }
    [self.keyboardControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height + KeyboardControlToolHeight);
    }];

    [self.view layoutIfNeeded];
}

#pragma mark - YDEmojiKeyboardDelegate
/**
 点击表情
 */
- (void)emojiKeyboard:(YDEmojiKeyboard *)emojiKB didSelectedEmojiItem:(YDEmoji *)emoji{
    if (self.inputingView == nil) {
        return;
    }
    if ([self.inputingView isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)self.inputingView;
        textView.text = [textView.text stringByAppendingFormat:@"%@",emoji.emojiName];
        
        [YDNotificationCenter postNotificationName:UITextViewTextDidChangeNotification object:textView];
    }
}

/**
 点击发送
 */
- (void)emojiKeyboardSendButtonDown{
    [self.emojiKeyboard dismissWithAnimation:YES];
    [self.keyboardControl dismissWithAnimated:YES];
}

/**
 点击删除
 */
- (void)emojiKeyboardDeleteButtonDown{
    YDPublishDynamicCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell deleteLastCharacter];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.keyboardControl.status = YDKeyboardControlStatusSystem;
}

- (void)keyboardDidShow:(NSNotification *)notification{
    
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    
    if (self.keyboardControl.status == YDKeyboardControlStatusEmoji) {
        return;
    }
    
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat sysKeyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height + KeyboardControlToolHeight;
    [UIView animateWithDuration:duration < 0.1 ? 0.1 : duration animations:^{
        [self.keyboardControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(sysKeyboardHeight);
            make.bottom.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    if (self.keyboardControl.status == YDKeyboardControlStatusEmoji) {
        return;
    }
    
    [self.keyboardControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(self.keyboardControl.height);
    }];
    [self.view layoutIfNeeded];
}

@end

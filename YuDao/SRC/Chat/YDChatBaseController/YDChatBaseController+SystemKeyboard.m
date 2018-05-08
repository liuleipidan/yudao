//
//  YDChatBaseController+SystemKeyboard.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatBaseController+SystemKeyboard.h"

@implementation YDChatBaseController (SystemKeyboard)

- (void)addSystemKeyboardNotifications{
    
    [YDNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [YDNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [YDNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [YDNotificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)removeSystemKeyboardNotifications{
    [YDNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [YDNotificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [YDNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [YDNotificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 系统键盘相关回调
- (void)keyboardWillShow:(NSNotification *)notification{
    if (_curStatus != YDChatBarStatusKeyboard) {
        return;
    }
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification{
    if (_curStatus != YDChatBarStatusKeyboard) {
        return;
    }
    if (_lastStatus == YDChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
    else if (_lastStatus == YDChatBarStatusEmoji){
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    if (_curStatus != YDChatBarStatusKeyboard && _lastStatus != YDChatBarStatusKeyboard) {
        return;
    }
    if (_curStatus == YDChatBarStatusEmoji || _curStatus == YDChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    if (_curStatus != YDChatBarStatusKeyboard && _lastStatus != YDChatBarStatusKeyboard) {
        return;
    }
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_lastStatus == YDChatBarStatusMore || _lastStatus == YDChatBarStatusEmoji) {
        if (keyboardFrame.size.height <= HEIGHT_CHAT_KEYBOARD) {
            return;
        }
    }
    else if (_curStatus == YDChatBarStatusMore || _curStatus == YDChatBarStatusEmoji){
        return;
    }
    
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-keyboardFrame.size.height);
    }];
    [self.view layoutIfNeeded];
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

@end

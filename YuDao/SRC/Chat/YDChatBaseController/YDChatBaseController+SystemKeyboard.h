//
//  YDChatBaseController+SystemKeyboard.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatBaseController.h"

@interface YDChatBaseController (SystemKeyboard)

- (void)addSystemKeyboardNotifications;

- (void)removeSystemKeyboardNotifications;

//------------------- 系统键盘相关回调 --------------------
- (void)keyboardWillShow:(NSNotification *)notification;

- (void)keyboardDidShow:(NSNotification *)notification;

- (void)keyboardWillHide:(NSNotification *)notification;

- (void)keyboardFrameWillChange:(NSNotification *)notification;

@end

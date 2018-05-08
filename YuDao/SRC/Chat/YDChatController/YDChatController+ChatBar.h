//
//  YDChatController+ChatBar.h
//  YuDao
//
//  Created by 汪杰 on 17/2/16.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatController.h"
#import "YDMoreKeyboard.h"
#import "YDEmojiKeyboard.h"
#import "TZImagePickerController.h"

@interface YDChatController (ChatBar)<YDChatBarDelegate,YDMoreKeyboardDelegate,YDKeyboardDelegate,TZImagePickerControllerDelegate,YDEmojiKeyboardDelegate>

/**
 ”更多“键盘
 */
@property (nonatomic, strong) YDMoreKeyboard *moreKeyboard;

/**
 ”表情“键盘
 */
@property (nonatomic, strong) YDEmojiKeyboard *emojiKeyboard;

- (void)addKeyboardNotifications;

- (void)loadKeyboard;
- (void)dismissKeyboard;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardFrameWillChange:(NSNotification *)notification;

@end

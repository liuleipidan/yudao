//
//  YDEmojiKeyboardDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDEmojiKeyboard,YDEmoji;
@protocol YDEmojiKeyboardDelegate <NSObject>

@optional
/**
 点击表情
 */
- (void)emojiKeyboard:(YDEmojiKeyboard *)emojiKB didSelectedEmojiItem:(YDEmoji *)emoji;

/**
 点击发送
 */
- (void)emojiKeyboardSendButtonDown;

/**
 点击删除
 */
- (void)emojiKeyboardDeleteButtonDown;

@end

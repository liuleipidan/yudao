//
//  YDChatBaseController+ChatBar.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatBaseController.h"

@interface YDChatBaseController (ChatBar)<YDChatBarDelegate,YDKeyboardDelegate,YDMoreKeyboardDelegate,YDEmojiKeyboardDelegate>

/**
 加载“更多”和“表情”键盘
 */
- (void)loadKeyboard;

/**
 隐藏“更多”和“标签”键盘
 */
- (void)dismissKeyboard;

@end

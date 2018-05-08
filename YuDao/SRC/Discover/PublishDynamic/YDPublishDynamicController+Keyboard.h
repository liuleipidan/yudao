//
//  YDPublishDynamicController+Keyboard.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPublishDynamicController.h"

@interface YDPublishDynamicController (Keyboard)<YDKeyboardControlDelegate,YDKeyboardDelegate,YDEmojiKeyboardDelegate>

- (void)addKeyboardNotifications;

@end

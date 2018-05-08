//
//  YDChatBaseController.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDChatBar.h"
#import "YDChatMessageDisplayView.h"
#import "YDMoreKBHelper.h"

#pragma mark - 键盘
#import "YDMoreKeyboard.h"
#import "YDEmojiKeyboard.h"

@interface YDChatBaseController : YDViewController
{
    YDChatBar *_chatBar;
    YDChatMessageDisplayView *_messageDisplayView;
    YDRecorderIndicatorView *_recorderIndicatorView;
    YDChatBarStatus _curStatus;
    YDChatBarStatus _lastStatus;
    YDMoreKeyboard *_moreKeyboard;
    YDEmojiKeyboard *_emojiKeyboard;
}

@property (nonatomic, strong) YDChatBar *chatBar;

@property (nonatomic, strong) YDChatMessageDisplayView *messageDisplayView;

@property (nonatomic, strong) YDRecorderIndicatorView *recorderIndicatorView;

/**
 chatBar的当前状态
 */
@property (nonatomic,assign) YDChatBarStatus curStatus;

/**
 chatBar的上一次状态
 */
@property (nonatomic,assign) YDChatBarStatus lastStatus;

/**
 “更多”键盘
 */
@property (nonatomic, strong) YDMoreKeyboard *moreKeyboard;

/**
 “表情”键盘
 */
@property (nonatomic, strong) YDEmojiKeyboard *emojiKeyboard;

@end

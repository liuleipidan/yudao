//
//  TLChatBar.h
//  TLChat
//
//  Created by 李伯坤 on 16/2/15.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDChatBarDelegate.h"
#import "YDChatTextView.h"

@interface YDChatBar : UIView

@property (nonatomic, assign) id<YDChatBarDelegate> delegate;

@property (nonatomic, assign) YDChatBarStatus status;

@property (nonatomic, strong) YDChatTextView *textView;

@property (nonatomic, strong, readonly) NSString *curText;

/// 是否激活状态（浏览个性表情时应该设置为NO）
@property (nonatomic, assign) BOOL activity;

/**
 *  添加EmojiB表情String
 */
- (void)addEmojiString:(NSString *)emojiString;

/**
 *  发送文字消息
 */
- (void)sendCurrentText;

/**
 *  删除最后一个字符
 */
- (void)deleteLastCharacter;

@end

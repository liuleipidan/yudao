//
//  YDEmojiGroupDisplayViewDelgate.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDEmoji;
@class YDEmojiGroupDisplayView;
@protocol YDEmojiGroupDisplayViewDelgate <NSObject>

/**
 *  发送按钮点击事件
 */
- (void)emojiGroupDisplayViewDeleteButtonPressed:(YDEmojiGroupDisplayView *)displayView;

/**
 *  选中表情
 */
- (void)emojiGroupDisplayView:(YDEmojiGroupDisplayView *)displayView didClickedEmoji:(YDEmoji *)emoji;

/**
 *  翻页
 */
- (void)emojiGroupDisplayView:(YDEmojiGroupDisplayView *)displayView didScrollToPageIndex:(NSInteger)pageIndex forGroupIndex:(NSInteger)groupIndex;

/**
 *  表情长按
 */
- (void)emojiGroupDisplayView:(YDEmojiGroupDisplayView *)displayView didLongPressEmoji:(YDEmoji *)emoji atRect:(CGRect)rect;

/**
 *  停止表情长按
 */
- (void)emojiGroupDisplayViewDidStopLongPressEmoji:(YDEmojiGroupDisplayView *)displayView;


@end

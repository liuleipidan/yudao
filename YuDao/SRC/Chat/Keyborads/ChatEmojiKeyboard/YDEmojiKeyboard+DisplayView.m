//
//  YDEmojiKeyboard+DisplayView.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/8.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiKeyboard+DisplayView.h"

@implementation YDEmojiKeyboard (DisplayView)

/**
 *  点击删除事件
 */
- (void)emojiGroupDisplayViewDeleteButtonPressed:(YDEmojiGroupDisplayView *)displayView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardDeleteButtonDown)]) {
        [self.delegate emojiKeyboardDeleteButtonDown];
    }
}

/**
 *  选中表情
 */
- (void)emojiGroupDisplayView:(YDEmojiGroupDisplayView *)displayView didClickedEmoji:(YDEmoji *)emoji{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:didSelectedEmojiItem:)]) {
        [self.delegate emojiKeyboard:self didSelectedEmojiItem:emoji];
    }
}

/**
 *  翻页
 */
- (void)emojiGroupDisplayView:(YDEmojiGroupDisplayView *)displayView didScrollToPageIndex:(NSInteger)pageIndex forGroupIndex:(NSInteger)groupIndex{
    [self.pageControl setCurrentPage:pageIndex];
}

/**
 *  表情长按
 */
- (void)emojiGroupDisplayView:(YDEmojiGroupDisplayView *)displayView didLongPressEmoji:(YDEmoji *)emoji atRect:(CGRect)rect{
    NSLog(@"%s",__func__);
}

/**
 *  停止表情长按
 */
- (void)emojiGroupDisplayViewDidStopLongPressEmoji:(YDEmojiGroupDisplayView *)displayView{
    NSLog(@"%s",__func__);
}

@end

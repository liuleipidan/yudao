//
//  TLChatBarDelegate.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/1.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDChatBar;
@protocol YDChatBarDelegate <NSObject>

/**
 *  chatBar状态改变
 */
- (void)chatBar:(YDChatBar *)chatBar changeStatusFrom:(YDChatBarStatus)fromStatus to:(YDChatBarStatus)toStatus;

/**
 *  输入框高度改变
 */
- (void)chatBar:(YDChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height;

/**
 *  发送文字
 */
- (void)chatBar:(YDChatBar *)chatBar sendText:(NSString *)text;

//------------------------ 录音相关代理 ----------------------
/**
 开始录音
 */
- (void)chatBarStartRecording:(YDChatBar *)chatBar;

/**
 将要取消录音
 */
- (void)chatBarWillCancelRecording:(YDChatBar *)chatBar cancel:(BOOL)cancel;

/**
 已经取消录音
 */
- (void)chatBarDidCancelRecording:(YDChatBar *)chatBar;

/**
 录音结束
 */
- (void)chatBarFinishedRecoding:(YDChatBar *)chatBar;

@end

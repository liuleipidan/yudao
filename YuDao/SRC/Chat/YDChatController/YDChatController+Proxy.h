//
//  YDChatController+Proxy.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatController.h"

@interface YDChatController (Proxy)<YDChatHelperDelegate>

/**
 *  发送图片消息
 */
- (void)sendImageMessage:(UIImage *)image;

/**
 *  发送视频消息
 */
- (void)sendVideoMessage:(NSURL *)videoUrl thumbnailImage:(UIImage *)thumbnailImage;

/**
 *  发送语言消息
 */
- (void)sendVoiceMessage:(YDVoiceChatMessage *)message;

/**
 *  发送消息
 */
- (void)sendMessage:(YDChatMessage *)message;

/**
 *  收到消息
 */
- (void)receivedMessage:(YDChatMessage *)message;


@end

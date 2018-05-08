//
//  YDEnumerateChat.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/26.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDEnumerateChat_h
#define YDEnumerateChat_h

/**
 *  消息读取状态
 */
typedef NS_ENUM(NSInteger, YDMessageReadState) {
    YDMessageUnRead = 0,        // 消息未读
    YDMessageReaded,            // 消息已读
};

/**
 *  消息发送状态
 */
typedef NS_ENUM(NSInteger, YDMessageSendState) {
    YDMessageSendSuccess = 0,   // 消息发送成功
    YDMessageSendFail,          // 消息发送失败
    YDMessageSending,           // 消息发送中
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, YDMessageType) {
    YDMessageTypeUnknown = 0,
    YDMessageTypeText = 10001,          // 文字
    YDMessageTypeVoice = 10002,         // 语音
    YDMessageTypeImage = 10003,         // 图片
    YDMessageTypeExpression = 10004,    // 表情
    YDMessageTypeVideo = 10005,         // 视频
    YDMessageTypeURL,                   // 链接
    YDMessageTypePosition,              // 位置
    YDMessageTypeBusinessCard,          // 名片
    YDMessageTypeSystem,                // 系统
    YDMessageTypeOther,
};

/**
 *  表情类型
 */
typedef NS_ENUM(NSInteger, YDEmojiType) {
    YDEmojiTypeEmoji = 0,
    YDEmojiTypeImage,
    YDEmojiTypeOther,
};

/**
 *  聊天键盘类型
 */
typedef NS_ENUM(NSInteger, YDChatBarStatus) {
    YDChatBarStatusInit,
    YDChatBarStatusVoice,
    YDChatBarStatusEmoji,
    YDChatBarStatusMore,
    YDChatBarStatusKeyboard,
};

/**
 *  "更多"键盘类型
 */
typedef NS_ENUM(NSUInteger, YDMoreKeyboardItemType) {
    YDMoreKeyboardItemTypeImage,
    YDMoreKeyboardItemTypeCamera,
    YDMoreKeyboardItemTypeVideo,
    YDMoreKeyboardItemTypeVideoCall,
    YDMoreKeyboardItemTypeWallet,
    YDMoreKeyboardItemTypeTransfer,
    YDMoreKeyboardItemTypePosition,
    YDMoreKeyboardItemTypeFavorite,
    YDMoreKeyboardItemTypeBusinessCard,
    YDMoreKeyboardItemTypeVoice,
    YDMoreKeyboardItemTypeCards,
};

#endif /* YDEnumerateChat_h */

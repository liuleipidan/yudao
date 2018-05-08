//
//  YDChatMessage.h
//  YuDao
//
//  Created by 汪杰 on 17/1/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDMessageFrame.h"
#import "YDChatMessageProtocol.h"

/**
 *  消息发送者类型
 */
typedef NS_ENUM(NSInteger, YDSenderType) {
    YDSenderTypeOther = 0,      //别人
    YDSenderTypeMyself,          // 自己
};
/**
 *  消息拥有者
 */
typedef NS_ENUM(NSInteger, YDMessageOwnerType){
    YDMessageOwnerTypeSelf,     // 自己发送的消息
    YDMessageOwnerTypeFriend,   // 接收到的他人消息
};


/**
 聊天消息基类
 */
@interface YDChatMessage : NSObject<YDChatMessageProtocol>
{
    YDMessageFrame *_messageFrame;
}

/**
 消息id
 */
@property (nonatomic, strong) NSString *msgId;

/**
 *  当前用户id
 */
@property (nonatomic, strong) NSNumber *uid;

/**
 好友id
 */
@property (nonatomic, strong) NSNumber *fid;

@property (nonatomic, strong) NSDate *date;

// 发送者类型
@property (nonatomic, assign) YDMessageOwnerType ownerType;

// 消息类型
@property (nonatomic, assign) YDMessageType messageType;

/*
 *用于表识内容的类型
 * 10001 -> 文字   10002 -> 位置   10003 -> URL
 */
@property (nonatomic, strong) NSNumber *code;
/**
 *  内容
 */
@property (nonatomic, strong) NSMutableDictionary *content;

//发送状态
@property (nonatomic, assign) YDMessageSendState sendState;

//读取状态
@property (nonatomic, assign) YDMessageReadState readState;



@property (nonatomic,assign) BOOL showName;

@property (nonatomic,assign) BOOL showTime;

@property (nonatomic, strong) YDMessageFrame *messageFrame;

/**
 对方头像链接
 */
@property (nonatomic, copy  ) NSString *fAvatarUrl;
/**
 对方名字
 */
@property (nonatomic, copy  ) NSString *fName;

/**
 *  根据相应的消息类型创建消息对象
 *
 *  @param type 消息类型
 *
 *  @return 消息对象
 */
+ (YDChatMessage *)createChatMessageByType:(YDMessageType )type;

/**
 重置大小
 */
- (void)resetMessageFrame;

@end

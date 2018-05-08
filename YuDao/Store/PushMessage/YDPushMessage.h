//
//  YDPushMessage.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YDPushMessageType) {
    YDPushMessageTypeSystem = 1,
    YDPushMessageTypeSocial,
};

/**
 *  好友请求接受状态
 */
typedef NS_ENUM(NSInteger, YDFriendRequestStatus) {
    YDFriendRequestStatusNormal = 0,
    YDFriendRequestStatusRefuse,
    YDFriendRequestStatusAccept,
};

@interface YDPushMessage : NSObject

/**
 消息id
 */
@property (nonatomic, strong) NSNumber *msgid;

/**
 消息父类型,1->系统,2->社交
 */
@property (nonatomic, assign) NSNumber *msgType;

/**
 消息子id
 */
@property (nonatomic, strong) NSNumber *msgSubtype;

/**
 当前用户id
 */
@property (nonatomic, strong) NSNumber *userid;

/**
 发送方id，系统消息默认为0
 */
@property (nonatomic, strong) NSNumber *senderid;

/**
 接收方id
 */
@property (nonatomic, strong) NSNumber *receiverid;

/**
 内容
 */
@property (nonatomic, copy  ) NSString *content;

/**
 时间，10位int时间戳
 */
@property (nonatomic, strong) NSNumber *time;

/**
 阅读状态
 */
@property (nonatomic, assign) YDMessageReadState  readState;;

/**
 名字，系统消息为“”，社交为发送方名字
 */
@property (nonatomic, copy  ) NSString *name;
/**
 名字，系统消息为“”，社交为发送方头像链接
 */
@property (nonatomic, copy  ) NSString *avatar;

/**
 好友请求的接收状态0->可接受，2->已接受
 */
@property (nonatomic, assign) YDFriendRequestStatus frStatus;   //接受状态

@end

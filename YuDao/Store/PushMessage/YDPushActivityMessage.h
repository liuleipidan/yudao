//
//  YDPushActivityMessage.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/22.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDPushActivityMessage : NSObject

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
@property (nonatomic, strong) NSDictionary *content;

/**
 时间，10位int时间戳
 */
@property (nonatomic, strong) NSNumber *time;

@property (nonatomic, copy  ) NSString *name;

@property (nonatomic, copy  ) NSString *avatar;

@end

@interface YDPushActivityMessageDetails : NSObject

@property (nonatomic,copy) NSString *aid;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *image;

@end


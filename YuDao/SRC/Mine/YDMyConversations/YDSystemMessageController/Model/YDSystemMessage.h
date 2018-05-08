//
//  YDSystemMessage.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/31.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YDSystemMessage : NSObject

#pragma mark - Common
//消息id
@property (nonatomic, strong) NSNumber *msgId;

//消息父类型
@property (nonatomic, strong) NSNumber *msgType;

//消息子类型
@property (nonatomic, strong) NSNumber *msgSubtype;

//消息子类型转枚举
@property (nonatomic, assign) YDSystemMessageType type;

//时间戳（十位数字）
@property (nonatomic, strong) NSNumber *time;

//是否显示时间，默认是YES
@property (nonatomic, assign) BOOL showTime;

//内容（Json字符串）
@property (nonatomic, copy  ) NSString *content;

#pragma mark - UI
//文本高度
@property (nonatomic, assign) CGFloat textHeight;

//所有内容高度
@property (nonatomic, assign) CGFloat wholeHeight;

//时间
@property (nonatomic, copy  ) NSString *timeInfo;

#pragma mark - Extensions

//---------------- 通用文本 ----------------
@property (nonatomic, copy, readonly) NSString *text;

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, copy  )         NSString *jumpText;

//---------------- 有人喜欢当前用户 ----------------
@property (nonatomic, strong, readonly) NSNumber *userId;

@property (nonatomic, copy, readonly) NSString *nickname;

@property (nonatomic, copy, readonly) NSString *avatarURL;

//---------------- 认证／审核失败、违章 ----------------
@property (nonatomic, strong, readonly) NSNumber *ug_id;

//---------------- 认证／审核是否需要跳转，1需要，0或nil不需要 ----------------
@property (nonatomic, assign, readonly) BOOL isSkip;

@end



//
//  YDConversation.h
//  YuDao
//
//  Created by 汪杰 on 16/11/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDConversation : NSObject

/**
 *  会话类型（个人，讨论组，企业号）
 */
@property (nonatomic, assign) YDConversationType convType;

/**
 *  消息提醒类型
 */
@property (nonatomic, assign) YDMessageRemindType remindType;

/**
 *  当前用户id
 */
@property (nonatomic, strong) NSNumber *uid;


/**
 *  好友id
 */
@property (nonatomic, strong) NSNumber *fid;

/**
 *  用户名
 */
@property (nonatomic, strong) NSString *fname;

/**
 *  头像地址（网络）
 */
@property (nonatomic, strong) NSString *fimageUrl;

/**
 *  头像地址（本地）
 */
@property (nonatomic, strong) NSString *avatarPath;

/**
 *  时间
 */
@property (nonatomic, strong) NSDate *date;



/**
 *  消息展示内容
 */
@property (nonatomic, strong) NSString *content;

//消息展示内容 - UI
@property (nonatomic, copy  ) NSAttributedString *attrContent;

/**
 *  提示红点类型
 */
@property (nonatomic, assign, readonly) YDClueType clueType;

//是否已读
@property (nonatomic, assign, readonly) BOOL isRead;

/**
 *  未读数量
 */
@property (nonatomic, assign) NSInteger unreadCount;

//显示时间
@property (nonatomic, copy  ) NSString *timeInfo;

@end

//
//  YDSystemMessageDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YDSystemMessageDelegate <NSObject>

@optional
/**
 收到新的系统消息
 */
- (void)receivedNewSystemMessages;

/**
 所有消息都已读
 */
- (void)systemMessagesAreRead;

/**
 有任务完成
 */
- (void)systemMessagesHadFinishTask;

@end

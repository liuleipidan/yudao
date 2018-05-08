//
//  YDChatMessageDisplayView.h
//  YuDao
//
//  Created by 汪杰 on 17/3/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDChatMessageViewDelegate.h"
#import "YDChatBaseCell.h"
#import "YDChatHelper+ConversationRecord.h"
#import "YDTableView.h"

@interface YDChatMessageDisplayView : UIView

@property (nonatomic,weak) id<YDChatMessageViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) YDTableView *tableView;

/// 禁用下拉加载
@property (nonatomic, assign) BOOL disablePullToRefresh;

/// 禁用长按菜单
@property (nonatomic, assign) BOOL disableLongPressMenu;


/**
 *  发送消息（在列表展示）
 */
- (void)addMessage:(YDChatMessage *)message;

/**
 *  删除消息
 */
- (void)deleteMessage:(YDChatMessage *)message;

- (void)deleteMessage:(YDChatMessage *)message withAnimation:(BOOL)animation;

/**
 *  更新消息状态
 */
- (void)updateMessage:(YDChatMessage *)message;

- (void)reloadData;

/**
 *  滚动到底部
 *
 *  @param animation 是否执行动画
 */
- (void)scrollToBottomWithAnimation:(BOOL)animation;

/**
 *  重新加载聊天信息
 */
- (void)resetMessageView;

- (void)updateMessageSendStatus:(NSString *)msgId
                     sendStatus:(YDMessageSendState)status;

@end

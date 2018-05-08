//
//  YDChatMessageViewDelegate.h
//  YuDao
//
//  Created by 汪杰 on 17/3/1.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDChatMessage;
@class YDChatMessageDisplayView;
@class YDUser;
@protocol YDChatMessageViewDelegate <NSObject>

/**
 *  聊天界面点击事件，用于收键盘
 */
- (void)chatMessageDisplayViewDidTouched:(YDChatMessageDisplayView *)chatTVC;

/**
 *  下拉刷新，获取某个时间段的聊天记录（异步）
 *
 *  @param chatTVC   chatTVC
 *  @param date      开始时间
 *  @param count     条数
 *  @param completed 结果Blcok
 */
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
            getRecordsFromDate:(NSDate *)date
                         count:(NSUInteger)count
                     completed:(void (^)(NSDate *, NSArray *, BOOL))completed;

@optional
/**
 *  消息长按删除
 *
 *  @return 删除是否成功
 */
- (BOOL)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
                 deleteMessage:(YDChatMessage *)message
                          rect:(CGRect)rect;

/**
 弹出长按cell的菜单视图
 */
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
          showCellMenuViewrect:(CGRect)rect
                       message:(YDChatMessage *)message;

/**
 *  用户头像点击事件
 */
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
            didClickUserAvatar:(NSNumber *)userId;

/**
 *  Message点击事件
 */
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
                     tapedView:(UIView *)tapedView
               didClickMessage:(YDChatMessage *)message;

/**
 *  Message双击事件
 */
- (void)chatMessageDisplayView:(YDChatMessageDisplayView *)chatTVC
         didDoubleClickMessage:(YDChatMessage *)message;

@end

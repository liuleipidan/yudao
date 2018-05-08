//
//  YDChatBaseCell.h
//  YuDao
//
//  Created by 汪杰 on 17/2/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDMessageCellDelegate.h"
#import "YDChatMessage.h"

@interface YDChatBaseCell : UITableViewCell
{
    
}
@property (nonatomic,weak) id<YDMessageCellDelegate> delegate;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *avatarButton;

@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UIImageView *messageBackgroundView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UIButton *failBtn;

/**
 发送中，默认是NO
 */
@property (nonatomic, assign) BOOL isSending;

@property (nonatomic, strong) YDChatMessage *message;

/**
 开始发送动画
 */
- (void)startSendAnimation;

/**
 停止发送动画
 */
- (void)stopSendAnimationWithSuccess:(BOOL )success;

- (UIImage *)resizebleImage:(YDMessageOwnerType) type;

/**
 *  更新消息，如果子类不重写，默认调用setMessage方法
 */
- (void)updateMessage:(YDChatMessage *)message;

- (void)changeMessageSendStatus:(YDMessageSendState )status;

- (void)setLongpressStatus:(BOOL)selected;

@end

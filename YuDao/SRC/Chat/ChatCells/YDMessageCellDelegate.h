//
//  YDMessageCellDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDChatMessage;
@protocol YDMessageCellDelegate <NSObject>

- (void)messageCellDidClickAvatarForUser:(NSNumber *)userId;

- (void)messageCellTapView:(UIView *)view message:(YDChatMessage *)message;

- (void)messageCellLongPress:(YDChatMessage *)message rect:(CGRect)rect;

- (void)messageCellDoubleClick:(YDChatMessage *)message;

@end

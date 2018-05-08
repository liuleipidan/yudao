//
//  UIFont+YuDao.h
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (YuDao)

//PingFangSC-Medium
+ (UIFont *)pingFangSC_MediumFont:(CGFloat)size;

+ (UIFont *)pingFangSC_RegularFont:(CGFloat)size;

#pragma mark - Common
+ (UIFont *)fontNavBarTitle;

#pragma mark - ShouYe

+ (UIFont *)font_12;
+ (UIFont *)font_13;
+ (UIFont *)font_14;
+ (UIFont *)font_15;
+ (UIFont *)font_16;
+ (UIFont *)font_17;
+ (UIFont *)font_18;

#pragma mark - Conversation
+ (UIFont *)fontConversationUsername;
+ (UIFont *)fontConversationDetail;
+ (UIFont *)fontConversationTime;

#pragma mark - Friends
+ (UIFont *) fontFriendsUsername;

#pragma mark - Mine
+ (UIFont *)fontMineNikename;
+ (UIFont *)fontMineUsername;

#pragma mark - Setting
+ (UIFont *)fontSettingHeaderAndFooterTitle;


#pragma mark - Chat
+ (UIFont *)fontTextMessageText;

@end

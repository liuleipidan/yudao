//
//  UIFont+YuDao.m
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "UIFont+YuDao.h"

@implementation UIFont (YuDao)

+ (UIFont *)pingFangSC_MediumFont:(CGFloat)size{
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (UIFont *)pingFangSC_RegularFont:(CGFloat)size{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *) fontNavBarTitle
{
    return [UIFont boldSystemFontOfSize:16.0f];
}

+ (UIFont *)font_12{
    return [UIFont systemFontOfSize:12.0f];
}
+ (UIFont *)font_13{
    return [UIFont systemFontOfSize:13.0f];
}
+ (UIFont *)font_14{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *)font_15{
    return [UIFont systemFontOfSize:15.0f];
}
+ (UIFont *)font_16{
    return [UIFont systemFontOfSize:16.0f];
}
+ (UIFont *)font_17{
    return [UIFont systemFontOfSize:17.0f];
}
+ (UIFont *)font_18{
    return [UIFont systemFontOfSize:18.0f];
}

+ (UIFont *) fontConversationUsername
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontConversationDetail
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontConversationTime
{
    return [UIFont systemFontOfSize:12.5f];
}

+ (UIFont *) fontFriendsUsername
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontMineNikename
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontMineUsername
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontSettingHeaderAndFooterTitle
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *)fontTextMessageText
{
    CGFloat size = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CHAT_FONT_SIZE"];
    if (size == 0) {
        size = 16.0f;
    }
    return [UIFont systemFontOfSize:size];
}


@end

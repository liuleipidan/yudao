//
//  YDRefreshTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDRefreshTool : NSObject

/**
 自定义动画下拉
 */
+ (MJRefreshGifHeader *)yd_MJheaderTarget:(id)target action:(SEL)action;

+ (MJRefreshGifHeader *)yd_MJheaderRefreshingBlock:(MJRefreshComponentRefreshingBlock )block;

/**
 自定义动画上拉
 */
+ (MJRefreshBackGifFooter *)yd_MJfooterTarget:(id)target action:(SEL)action;

+ (MJRefreshBackGifFooter *)yd_MJfooterRefreshingBlock:(MJRefreshComponentRefreshingBlock )block;


@end

//
//  YDMineMenuItem.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMineMenuItem.h"

@implementation YDMineMenuItem

+ (YDMineMenuItem *)createItemWithIconPath:(NSString *)iconPath title:(NSString *)title{
    YDMineMenuItem *item = [[YDMineMenuItem alloc] init];
    item.iconPath = iconPath;
    item.title = title;
    return item;
}

@end

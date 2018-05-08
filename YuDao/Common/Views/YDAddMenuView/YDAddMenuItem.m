//
//  YDAddMenuItem.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAddMenuItem.h"

@implementation YDAddMenuItem

+ (YDAddMenuItem *)createWithType:(YDAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath{
    YDAddMenuItem *item = [[YDAddMenuItem alloc] init];
    item.type = type;
    item.title = title;
    item.iconPath = iconPath;
    return item;
}

@end

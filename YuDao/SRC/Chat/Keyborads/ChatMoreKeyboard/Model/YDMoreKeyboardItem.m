//
//  YDMoreKeyboardItem.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMoreKeyboardItem.h"

@implementation YDMoreKeyboardItem

+ (YDMoreKeyboardItem *)createByType:(YDMoreKeyboardItemType )type
                               title:(NSString *)title
                           imagePath:(NSString *)imagePath{
    YDMoreKeyboardItem *item = [YDMoreKeyboardItem new];
    item.type = type;
    item.title = title;
    item.imagePath = imagePath;
    return item;
}

@end

//
//  YDMoreKBHelper.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMoreKBHelper.h"
#import "YDMoreKeyboardItem.h"

@implementation YDMoreKBHelper

- (id)init{
    if (self = [super init]) {
        _chatMoreKBData = [NSMutableArray array];
        [self y_initMoreKBData];
    }
    return self;
}

- (void)y_initMoreKBData{
    YDMoreKeyboardItem *imageItem = [YDMoreKeyboardItem createByType:YDMoreKeyboardItemTypeImage title:@"照片" imagePath:@"chat_toolbar_image"];
    YDMoreKeyboardItem *cameraItem = [YDMoreKeyboardItem createByType:YDMoreKeyboardItemTypeCamera title:@"拍摄" imagePath:@"chat_toolbar_camera"];
    [_chatMoreKBData addObjectsFromArray:@[imageItem,cameraItem]];
    
}

@end

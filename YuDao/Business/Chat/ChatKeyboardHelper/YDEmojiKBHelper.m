//
//  YDEmojiKBHelper.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/8.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiKBHelper.h"

static YDEmojiKBHelper *emojiHepler = nil;

@implementation YDEmojiKBHelper

+ (YDEmojiKBHelper *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojiHepler = [[YDEmojiKBHelper alloc] init];
    });
    return emojiHepler;
}

- (id)init{
    if (self = [super init]) {
        _emojiGroupData = [NSMutableArray arrayWithObject:self.defaultFaceGroup];
    }
    return self;
}

- (YDEmojiGroup *)defaultFaceGroup{
    if (_defaultFaceGroup == nil) {
        _defaultFaceGroup = [YDEmojiGroup new];
        _defaultFaceGroup.type = YDEmojiTypeEmoji;
        _defaultFaceGroup.groupID = @"default";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FaceEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray<YDEmoji *> *emojis = [YDEmoji mj_objectArrayWithKeyValuesArray:data];
        [emojis enumerateObjectsUsingBlock:^(YDEmoji * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.type = YDEmojiTypeEmoji;
        }];
        
        _defaultFaceGroup.data = [NSMutableArray arrayWithArray:emojis];
    }
    return _defaultFaceGroup;
}

@end

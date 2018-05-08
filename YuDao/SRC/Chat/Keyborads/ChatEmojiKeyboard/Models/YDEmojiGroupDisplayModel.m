//
//  YDEmojiGroupDisplayModel.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiGroupDisplayModel.h"

@implementation YDEmojiGroupDisplayModel

- (id)initWithEmojiGroup:(YDEmojiGroup *)group
              pageNumber:(NSUInteger)pageNumber
                   count:(NSUInteger)count{
    if (self = [super init]) {
        self.groupID = group.groupID;
        self.groupName = group.groupName;
        self.type = group.type;
        
        self.rowNumber = group.rowNumber;
        self.colNumber = group.colNumber;
        self.pageItemCount = group.pageItemCount;
        
        NSInteger start = pageNumber * count;
        if (start < group.data.count) {
            NSInteger len = MIN(count, group.count - start);
            self.data = [group.data subarrayWithRange:NSMakeRange(pageNumber * count, len)];
        }
    }
    return self;
}

- (id)objectAtIndex:(NSUInteger)index{
    return index < self.data.count ? [self.data objectAtIndex:index] : nil;
}

- (void)addEmoji:(YDEmoji *)emoji{
    NSMutableArray *emojis = [NSMutableArray arrayWithArray:self.data];
    [emojis addObject:emoji];
    self.data = emojis;
}

@end

//
//  YDEmojiGroup.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiGroup.h"

@implementation YDEmojiGroup

- (void)setData:(NSMutableArray *)data{
    _data = data;
    self.count = data.count;
    self.pageItemCount = self.rowNumber * self.colNumber;
    self.pageNumber = self.count / self.pageItemCount + (self.count % self.pageItemCount == 0 ? 0 : 1);
}

- (id)objectAtIndex:(NSUInteger)index{
    if (index < self.data.count) {
        return [self.data objectAtIndex:index];
    }
    return nil;
}

- (NSUInteger)rowNumber{
    if (self.type == YDEmojiTypeEmoji) {
        return 3;
    }
    return 2;
}

- (NSUInteger)colNumber{
    if (self.type == YDEmojiTypeEmoji) {
        return 8;
    }
    return 4;
}

- (NSUInteger)pageItemCount{
    if (self.type == YDEmojiTypeEmoji) {
        return self.rowNumber * self.colNumber - 1;
    }
    return self.rowNumber * self.colNumber;
}

- (NSUInteger)pageNumber{
    return self.count / self.pageItemCount + (self.count % self.pageItemCount == 0 ? 0 : 1);
}

@end

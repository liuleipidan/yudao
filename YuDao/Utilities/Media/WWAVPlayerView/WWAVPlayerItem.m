//
//  WWAVPlayerItem.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "WWAVPlayerItem.h"

@implementation WWAVPlayerItem

- (void)dealloc{
    if (self.observer) {
        [self removeObserver:self.observer forKeyPath:@"status"];
        [self removeObserver:self.observer forKeyPath:@"loadedTimeRanges"];
    }
}

@end

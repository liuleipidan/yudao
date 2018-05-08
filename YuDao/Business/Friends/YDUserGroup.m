//
//  YDUserGroup.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDUserGroup.h"

@implementation YDUserGroup

- (id)initWithGroupName:(NSString *)groupName users:(NSMutableArray *)users{
    if (self = [super init]) {
        self.groupName = groupName;
        self.users = users;
    }
    return self;
}

- (NSMutableArray *)users{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

- (NSInteger)count{
    return self.users.count;
}

- (void)addObject:(id)anObject{
    [self.users addObject:anObject];
}

- (void)removeObject:(id)anObject{
    [self.users removeObject:anObject];
}

- (id)objectAtIndex:(NSUInteger)index{
    return [self.users objectAtIndex:index];
}

@end

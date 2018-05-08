//
//  YDUserGroup.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDUserGroup : NSObject

@property (nonatomic,copy  ) NSString *groupName;

@property (nonatomic,strong) NSMutableArray *users;

@property (nonatomic,assign, readonly) NSInteger count;

- (id)initWithGroupName:(NSString *)groupName users:(NSMutableArray *)users;

- (void)addObject:(id)anObject;

- (void)removeObject:(id)anObject;

- (id)objectAtIndex:(NSUInteger )index;

@end

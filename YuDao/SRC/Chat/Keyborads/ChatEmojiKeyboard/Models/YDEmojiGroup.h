//
//  YDEmojiGroup.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDEmoji.h"

@interface YDEmojiGroup : NSObject

@property (nonatomic, assign) YDEmojiType type;

@property (nonatomic, copy  ) NSString *groupID;

@property (nonatomic, copy  ) NSString *groupName;

@property (nonatomic, copy  ) NSString *path;

@property (nonatomic, copy  ) NSString *groupIconPath;

@property (nonatomic, copy  ) NSString *groupIconURL;

@property (nonatomic, strong) NSMutableArray *data;

//总数
@property (nonatomic, assign) NSUInteger count;

#pragma mark - UI

//每页个数
@property (nonatomic, assign) NSUInteger pageItemCount;

//页数
@property (nonatomic, assign) NSUInteger pageNumber;

//行数
@property (nonatomic, assign) NSUInteger rowNumber;

//列数
@property (nonatomic, assign) NSUInteger colNumber;

- (id)objectAtIndex:(NSUInteger)index;

@end

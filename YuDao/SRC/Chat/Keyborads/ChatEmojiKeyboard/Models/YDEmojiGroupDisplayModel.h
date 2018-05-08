//
//  YDEmojiGroupDisplayModel.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDEmojiGroup.h"

@interface YDEmojiGroupDisplayModel : NSObject

@property (nonatomic, assign) YDEmojiType type;

@property (nonatomic, copy  ) NSString *groupID;

@property (nonatomic, copy  ) NSString *groupName;

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) NSArray *data;

#pragma mark - 标记

@property (nonatomic, assign) NSInteger emojiGroupIndex;

@property (nonatomic, assign) NSInteger pageIndex;

#pragma mark - UI

//每页个数
@property (nonatomic, assign) NSUInteger pageItemCount;

//页数
@property (nonatomic, assign) NSUInteger pageNumber;

//行数
@property (nonatomic, assign) NSUInteger rowNumber;

//列数
@property (nonatomic, assign) NSUInteger colNumber;

//cell大小
@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, assign) UIEdgeInsets sectionInsets;

- (id)initWithEmojiGroup:(YDEmojiGroup *)group
              pageNumber:(NSUInteger)pageNumber
                   count:(NSUInteger)count;

- (id)objectAtIndex:(NSUInteger)index;

- (void)addEmoji:(YDEmoji *)emoji;

@end

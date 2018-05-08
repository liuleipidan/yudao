//
//  YDSettingGroup.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDSettingItem.h"

#define YDCreateSettingGroup(Header, Hooter, Items) [YDSettingGroup createGroupWithHeaderTitle:Header footerTitle:Hooter items:[NSMutableArray arrayWithArray:Items]]

@interface YDSettingGroup : NSObject

/**
 section头部标题
 */
@property (nonatomic, copy  ) NSString *headerTitle;

/**
 section尾部说明
 */
@property (nonatomic, copy  ) NSString *footerTitle;

/**
 section元素
 */
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign, readonly) CGFloat headerHeight;

@property (nonatomic, assign, readonly) CGFloat footerHeight;

@property (nonatomic, assign, readonly) NSUInteger count;

+ (YDSettingGroup *)createGroupWithHeaderTitle:(NSString *)headerTitle
                                   footerTitle:(NSString *)footerTitle
                                         items:(NSMutableArray *)items;

- (id)objectAtIndex:(NSUInteger )index;

- (NSUInteger)indexOfObject:(id)obj;

- (void)removeObject:(id)obj;

@end

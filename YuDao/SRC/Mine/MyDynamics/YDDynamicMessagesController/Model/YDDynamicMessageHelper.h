//
//  YDDynamicMessageHelper.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDDynamicMessage.h"

@interface YDDynamicMessageHelper : NSObject

/**
 点赞或评论的消息的数量
 */
@property (nonatomic,assign) NSUInteger count;

/**
 点赞或评论的消息数组
 */
@property (nonatomic, strong) NSArray<YDDynamicMessage *> *messages;

@end

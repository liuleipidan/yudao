//
//  YDEmojiKBHelper.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/8.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDEmojiGroup.h"

@interface YDEmojiKBHelper : NSObject

@property (nonatomic, strong) NSMutableArray *emojiGroupData;

@property (nonatomic, strong) YDEmojiGroup *defaultFaceGroup;

+ (YDEmojiKBHelper *)sharedInstance;

@end

//
//  YDEmoji.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDEmoji : NSObject

@property (nonatomic, assign) YDEmojiType type;

@property (nonatomic, copy  ) NSString *groupID;

@property (nonatomic, copy  ) NSString *emojiID;

@property (nonatomic, copy  ) NSString *emojiName;

@property (nonatomic, copy  ) NSString *emojiPath;

@property (nonatomic, copy  ) NSString *emojiURL;

@property (nonatomic, assign) CGSize size;

@end

//
//  YDMoreKeyboardItem.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDMoreKeyboardItem : NSObject

@property (nonatomic, assign) YDMoreKeyboardItemType type;

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *imagePath;

+ (YDMoreKeyboardItem *)createByType:(YDMoreKeyboardItemType )type
                               title:(NSString *)title
                           imagePath:(NSString *)imagePath;

@end

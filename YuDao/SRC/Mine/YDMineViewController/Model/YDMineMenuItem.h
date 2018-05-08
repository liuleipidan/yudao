//
//  YDMineMenuItem.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YDCreateMineMenuItem(IconPath,Title) [YDMineMenuItem createItemWithIconPath:IconPath title:Title]

@interface YDMineMenuItem : NSObject

@property (nonatomic, copy  ) NSString *iconPath;

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *subTitle;

@property (nonatomic, copy  ) NSString *rightIconURL;

@property (nonatomic, assign) NSUInteger unredCount;

+ (YDMineMenuItem *)createItemWithIconPath:(NSString *)iconPath title:(NSString *)title;




@end

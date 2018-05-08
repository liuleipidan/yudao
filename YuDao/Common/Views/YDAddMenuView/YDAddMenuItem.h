//
//  YDAddMenuItem.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDAddMenuItem : NSObject

@property (nonatomic, assign) YDAddMneuType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *iconPath;

+ (YDAddMenuItem *)createWithType:(YDAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath;

@end

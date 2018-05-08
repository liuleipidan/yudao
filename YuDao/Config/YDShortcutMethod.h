//
//  YDShortcutMethod.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/29.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDShortcutMethod : NSObject

+ (NSString *)appBundleName;

+ (NSString *)appBundleID;

+ (NSString *)appVersion;

+ (NSString *)appBuildVersion;

//设备型号
+ (NSString *)deviceModel;



@end

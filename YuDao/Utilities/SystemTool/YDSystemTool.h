//
//  YDSystemTool.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 系统工具，用于挑起设备自带功能，例如打电话
 */
@interface YDSystemTool : NSObject

+ (void)st_callToSomeOneWithPhone:(NSString *)phone;

@end

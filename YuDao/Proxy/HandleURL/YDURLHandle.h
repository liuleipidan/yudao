//
//  YDURLHandle.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YDURLHandle : NSObject

/**
 处理其他app或浏览器打开此本app
 */
+ (void)handleOpenURL:(NSURL *)url;

@end

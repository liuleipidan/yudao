//
//  YDLaunchImageAdTool.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDLaunchImageAdToolConfig.h"

#define kGetLaunchImageURL [kOriginalURL stringByAppendingString:@"getappcover"]

@interface YDLaunchImageAdTool : NSObject

@property (nonatomic,copy) YDLaunchImageDismissBlock dismissBlock;

@property (nonatomic, copy, readonly) NSString *imageURL;

@property (nonatomic, assign) BOOL isShow;

- (void)showImageByLocalPath:(NSString *)path dismissBlock:(YDLaunchImageDismissBlock)dismissBlock;

- (void)showImageByURL:(NSString *)url dismissBlock:(YDLaunchImageDismissBlock)dismissBlock;

- (void)showAdImageByDismissBlock:(YDLaunchImageDismissBlock)dismissBlock;

@end

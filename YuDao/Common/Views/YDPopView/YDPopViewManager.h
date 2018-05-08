//
//  YDPopViewManager.h
//  YuDao
//
//  Created by 汪杰 on 17/3/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDPopViewManager : NSObject

+ (YDPopViewManager *)shareIntance;

+ (void)attemptDealloc;

- (void)showPopViewWithUserName:(NSString *)name
                   leftImageUrl:(NSString *)leftImageUrl
                  rightImageUrl:(NSString *)rightImageUrl
                  selectedBlock:(void (^)(NSInteger index))selectedBlock;


@end

//
//  YDAllDynamicController.h
//  YuDao
//
//  Created by 汪杰 on 16/12/22.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDViewController.h"

@class YDAllDynamicController,YDMoment;
@protocol YDAllDynamicControllerDelegate <NSObject>

/**
 当前用户发布了新动态

 @param controller 逛一逛控制器
 @param userId 发布动态的用户id
 */
- (void)allDynamicController:(YDAllDynamicController *)controller publishedNewDynamic:(NSNumber *)userId;


@end

@interface YDAllDynamicController : YDViewController

@property (nonatomic, assign) NSInteger fromFlag;

+ (YDAllDynamicController *)sharedAlldynamicVC;


@end

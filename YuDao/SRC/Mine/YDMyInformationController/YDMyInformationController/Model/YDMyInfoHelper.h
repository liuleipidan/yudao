//
//  YDMyInfoHelper.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDMyInfoItem.h"

@interface YDMyInfoHelper : NSObject

@property (nonatomic, strong) NSArray *data;

//暂存用户信息
@property (nonatomic, strong) YDUser *tempUserInfo;

/**
 通过用户信息作UI分组
 */
- (NSArray *)myInformationDataByUserInfo:(YDUser *)user;


/**
 刷新用户信息
 */
- (void)reloadUserInfo:(YDUser *)user avatar:(UIImage *)avatarImage;

@end

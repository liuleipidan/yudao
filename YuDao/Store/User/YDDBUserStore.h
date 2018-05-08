//
//  YDDBUserStore.h
//  YuDao
//
//  Created by 汪杰 on 16/11/7.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDUser.h"

@interface YDDBUserStore : YDDBBaseStore

/**
 *  新的用户
 */
- (BOOL)insertOrUpdateUserByUser:(YDUser *)user;

/**
 *  获取当前用户
 *
 */
- (void)getCurrentUser:(NSNumber *)uid currentUser:(YDUser *)user;

/**
 *  删除单个用户
 */
- (BOOL)deleteUserByUid:(NSString *)uid;

/**
 *  删除用户的所有用户
 */
- (BOOL)deleteUsers;

@end

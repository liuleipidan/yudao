//
//  YDFriendStore.h
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDFriendModel.h"

@interface YDDBFriendStore : YDDBBaseStore



/**
 *  添加好友
 *
 */
- (BOOL)addFriend:(YDFriendModel *)user;

/**
 *  获得所有好友
 *
 */
- (NSMutableArray *)friendsDataByUid:(NSNumber *)uid;


- (YDFriendModel *)friendByUid:(NSNumber *)uid friendId:(NSNumber *)fid;

/**
 *  查询是否存在此好友
 *
 */
- (BOOL )friendIsInExistenceByUid:(NSNumber *)uid;

/**
 *  删除好友
 *
 */
- (BOOL)deleteFriendByFid:(NSNumber *)fid forUid:(NSNumber *)uid;


/**
 删除所有好友

 @return 删除是否成功
 */
- (BOOL)deleteAllFriends;

/**
 *  查询好友,通过名字或者id
 */
- (void )searchFriendByName:(NSString *)name orId:(NSNumber *)fid completion:(void (^)(NSArray *data))completion;

- (NSInteger)countAllFriends;

@end

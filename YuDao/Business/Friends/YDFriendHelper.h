//
//  YDFriendHelper.h
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDFriendModel.h"

@interface YDFriendHelper : NSObject

@property (nonatomic,strong) YDUserGroup *defaultGroup;

#pragma mark - 好友

/// 好友数据(原始)
@property (nonatomic, strong) NSMutableArray<YDFriendModel *> *friendsData;

/// 格式化的好友数据（二维数组，列表用）
@property (nonatomic, strong) NSMutableArray *data;

/// 格式化好友数据的分组标题
@property (nonatomic, strong) NSMutableArray *sectionHeaders;

///  好友数量
@property (nonatomic, assign, readonly) NSInteger friendCount;

/**
 初始化数据或重置数据的回调
 */
@property (nonatomic, copy  ) void(^dataChangedBlock)(NSMutableArray *data, NSMutableArray *sectionHeaders, NSInteger friendCount);


+ (YDFriendHelper *)sharedFriendHelper;

+ (void)attemptDealloc;

//下载好友数据
- (void)downloadFriendsData:(void (^)(NSArray *data, NSArray *headers, NSInteger count))completeBlock;

/**
 从数据库读取好友数据并排序

 @param completeBlock 排序完成
 */
- (void)yd_resetFriendData:(void (^)(NSArray *data, NSArray *headers, NSInteger count))completeBlock;

- (YDFriendModel *)getFriendInfoByFid:(NSNumber *)fid;

/**
 *  查询是否存在此好友
 *
 */
- (BOOL )friendIsInExistenceByUid:(NSNumber *)uid;

/**
 *  查询好友,通过名字或者id
 */
- (void )searchFriendByName:(NSString *)name orId:(NSNumber *)fid completion:(void (^)(NSArray *data))completion;

/**
 *  添加好友
 *
 */
- (BOOL )addFriendByModel:(YDFriendModel *)model;

/**
 *  删除好友
 *
 */
- (BOOL )deleteFriendByFid:(NSNumber *)fid;

/**
 删除所有好友

 @return YES or NO
 */
- (BOOL )deleteAllFriends;

//统计好友数量
- (NSInteger )countAllFriends;

@end

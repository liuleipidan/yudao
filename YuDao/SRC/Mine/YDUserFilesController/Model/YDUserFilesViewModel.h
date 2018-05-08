//
//  YDUserFilesViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDUserInfoModel.h"
#import "YDMoment.h"

@interface YDUserFilesViewModel : NSObject

/**
 当前用户id
 */
@property (nonatomic, strong) NSNumber *uid;

/**
 用户昵称
 */
@property (nonatomic, copy  ) NSString *userName;

/**
 用户头像网址
 */
@property (nonatomic, copy  ) NSString *userHeaderUrl;

/**
 用户信息
 */
@property (nonatomic, strong) YDUserInfoModel *userInfo;

/**
 当前动态的页码
 */
@property (nonatomic, assign) NSInteger pageIndex;

/**
 每次请求动态的数量
 */
@property (nonatomic, assign) NSInteger pageSize;

/**
 动态数组
 */
@property (nonatomic, strong) NSMutableArray<YDMoment *> *dynamics;

- (instancetype)initWithUserId:(NSNumber *)uid;

- (void)requestUserInformation:(void (^)(void))success
                       failure:(void (^)(void))failure;

- (void)requestUserDynamics:(void (^)(BOOL hasMore))success
                    failure:(void (^)(void))failure;

@end

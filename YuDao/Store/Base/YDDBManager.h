//
//  YDDBManager.h
//  YuDao
//
//  Created by 汪杰 on 16/10/25.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface YDDBManager : NSObject

/**
 *  DB队列（除IM相关）
 */
@property (nonatomic, strong) FMDatabaseQueue *commonQueue;

/**
 *  通用数据相关队列
 */
@property (nonatomic, strong) FMDatabaseQueue *sysCommonQueue;

/**
 *  与IM相关的DB队列
 */
@property (nonatomic, strong) FMDatabaseQueue *messageQueue;

+ (YDDBManager *)sharedInstance;



@end

//
//  YDMomentProxy.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDMoment.h"

@interface YDMomentProxy : NSObject

@property (nonatomic, strong) NSMutableArray<YDMoment *> *moments;

/**
 没有更多了，默认是NO
 */
@property (nonatomic, assign) BOOL noMore;

/**
 请求动态数据

 @param type 动态数据类型
 @param completion 请求结束
 */
- (void)requestMomentsByControllerType:(YDGowalkViewControllerType )type
                            completion:(void (^)(YDRequestReturnDataType dataType))completion;

/**
 请求更多动态数据

 @param type 动态数据类型
 @param completion 请求结束
 */
- (void)requestMoreMomentsByControllerType:(YDGowalkViewControllerType )type
                                completion:(void (^)(YDRequestReturnDataType dataType))completion;

@end

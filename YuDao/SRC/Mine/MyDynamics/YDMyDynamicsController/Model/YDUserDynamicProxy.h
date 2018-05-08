//
//  YDUserDynamicProxy.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDMoment.h"

@interface YDUserDynamicProxy : NSObject

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic,assign) NSUInteger pageIndex;

@property (nonatomic,assign,readonly) NSUInteger pageSize;

@property (nonatomic, strong) NSMutableArray *dynamics;

- (void)requestDynamicsCompletion:(void (^)(YDRequestReturnDataType dataType))completion;

@end

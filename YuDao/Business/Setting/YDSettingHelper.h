//
//  YDSettingHelper.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDSettingGroup.h"

@interface YDSettingHelper : NSObject

@property (nonatomic, strong) NSMutableArray *mainSettingData;

@property (nonatomic, strong) NSMutableArray *functionSettingData;

@property (nonatomic, strong) NSMutableArray *messageSettingData;

+ (void)addHPIgnoreByIgnoreModel:(YDHPIgnoreModel *)model
                         success:(void (^)(YDHPIgnoreModel * model))success
                         failure:(void (^)(void))failure;

+ (void)deleteHPIgnoreBy:(YDHPIgnoreModel *)model
                 success:(void (^)(void))success
                 failure:(void (^)(void))failure;

@end

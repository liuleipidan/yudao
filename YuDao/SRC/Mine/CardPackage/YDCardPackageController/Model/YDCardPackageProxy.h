//
//  YDCardPackageHelper.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDCard.h"

@interface YDCardPackageProxy : NSObject

@property (nonatomic, strong) NSMutableArray<YDCard *> *data;

/**
 请求前十条卡券

 @param completion 数据返回类型
 */
- (void)requestCardPackageCompletion:(void (^)(YDRequestReturnDataType))completion;

/**
 请求十条以后的卡券

 @param completion 数据返回类型
 */
- (void)requestMoreCardseCompletion:(void (^)(YDRequestReturnDataType))completion;

/**
 请求卡券详情信息

 @param couponId 卡券id
 @param success 成功
 @param failure 失败
 */
+ (void)requestCardDetailsByCouponId:(NSNumber *)couponId
                             success:(void (^)(YDCard *card))success
                             failure:(void (^)(void))failure;

@end

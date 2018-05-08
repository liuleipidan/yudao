//
//  YDDBCarBrandStore.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"
#import "YDCarBrand.h"

//车辆品牌数据的条数
#define kCarBrandDataCount 180

@interface YDDBCarBrandStore : YDDBBaseStore

+ (YDDBCarBrandStore *)manager;

/**
 插入车辆品牌
 */
- (BOOL)insertCarBrands:(NSArray<YDCarBrand *> *)brands;

/**
 统计已有的车辆品牌数量
 */
- (NSUInteger)countCarBrands;

/**
 所有车辆品牌数据
 */
- (NSArray *)carBrands;

@end

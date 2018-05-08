//
//  YDCarBrand.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDCarModelProtocol.h"

#define YDCreateCarBrandModel(Vb_id, Name, Firstletter, Logo, LogoPath) [YDCarBrand createCarBrandBy:Vb_id name:Name firstletter:Firstletter logo:Logo logoPath:LogoPath]

@interface YDCarBrand : NSObject<YDCarModelProtocol>

//品牌id
@property (nonatomic, strong) NSNumber *vb_id;

//品牌名
@property (nonatomic, copy  ) NSString *vb_name;

//首字母
@property (nonatomic, copy  ) NSString *firstletter;

//品牌logoURL
@property (nonatomic, copy  ) NSString *logo;

//品牌logo本地路径
@property (nonatomic, copy  ) NSString *logoPath;

//此品牌是否可用,0->可用，1->不可用
@property (nonatomic, strong) NSNumber *disabled;

/**
 索引数组
 */
+ (NSArray *)indexArrayFromDataSource:(NSArray<id<YDCarModelProtocol>> *)dataSource;

/**
 分组后的数组
 */
+ (NSArray *)groupedArrayFormDataSource:(NSArray<id<YDCarModelProtocol>> *)dataSource;

/**
 排序后的数组
 */
+ (NSArray *)sortedArrayFormDataSource:(NSArray<id<YDCarModelProtocol>> *)dataSource;

+ (YDCarBrand *)createCarBrandBy:(NSNumber *)vb_id
                            name:(NSString *)name
                     firstletter:(NSString *)firstletter
                            logo:(NSString *)logo
                        logoPath:(NSString *)logoPath;

@end

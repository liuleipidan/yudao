//
//  YDCarBrand.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarBrand.h"
#import "NSString+PinYin.h"

@implementation YDCarBrand

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"firstletter":@"vb_firstletter",
             @"logo":@"vb_logo"
             };
}

+ (YDCarBrand *)createCarBrandBy:(NSNumber *)vb_id
                            name:(NSString *)name
                     firstletter:(NSString *)firstletter
                            logo:(NSString *)logo
                        logoPath:(NSString *)logoPath{
    YDCarBrand *brand = [YDCarBrand new];
    brand.vb_id = vb_id;
    brand.vb_name = name;
    brand.firstletter = firstletter;
    brand.logo = logo;
    brand.logoPath = logoPath;
    
    return brand;
}

//索引数组
+ (NSArray *)indexArrayFromDataSource:(NSArray<id<YDCarModelProtocol>> *)dataSource{
    NSMutableArray *indexArr = [NSMutableArray array];
    __block NSString *tempString = nil;
    [dataSource enumerateObjectsUsingBlock:^(id<YDCarModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *indexString = [obj nameFirstWord];
        if (![tempString isEqualToString:indexString]) {
            [indexArr addObject:indexString];
            tempString = indexString;
        }
    }];
    return [NSArray arrayWithArray:indexArr];
}

//分组后的数组
+ (NSArray *)groupedArrayFormDataSource:(NSArray<id<YDCarModelProtocol>> *)dataSource{
    NSMutableArray *tempArr = [NSMutableArray array];
    __block NSMutableArray *item = [NSMutableArray array];
    __block NSString *tempString = nil;
    [dataSource enumerateObjectsUsingBlock:^(id<YDCarModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *indexString = [obj nameFirstWord];
        if (![tempString isEqualToString:indexString]) {
            item = [NSMutableArray array];
            [item addObject:obj];
            [tempArr addObject:item];
            
            //往下遍历
            tempString = indexString;
        }
        else{
            [item addObject:obj];
        }
    }];
    return [NSArray arrayWithArray:tempArr];
}

//排序
+ (NSArray *)sortedArrayFormDataSource:(NSArray<id<YDCarModelProtocol>> *)dataSource{
    NSMutableArray *tempArray =[NSMutableArray arrayWithArray:dataSource];
    //按照nameFirstWord进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nameFirstWord" ascending:YES]];
    [tempArray sortUsingDescriptors:sortDescriptors];
    return tempArray;
}

#pragma mark - YDCarModelProtocol
- (NSString *)nameFirstWord{
    if (self.firstletter.length > 0) {
        return self.firstletter;
    }
    return self.vb_name.pinyinInitial;
}

@end

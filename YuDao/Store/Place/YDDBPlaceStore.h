//
//  YDDBPlaceStore.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/26.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDBBaseStore.h"

@interface YDPlace : NSObject

@property (nonatomic, strong) NSNumber *currentId;

@property (nonatomic, strong) NSNumber *pId;

@property (nonatomic, copy  ) NSString *name;

@end

@interface YDDBPlaceStore : YDDBBaseStore

- (BOOL)placeTableExist;

- (BOOL)addPlace:(YDPlace *)model;

- (BOOL)insertPlaces:(NSArray<YDPlace *> *)places;

- (NSUInteger)countPlaces;

- (NSArray *)provinces;

- (NSArray *)placesByCurrentId:(NSNumber *)currentId;

@end

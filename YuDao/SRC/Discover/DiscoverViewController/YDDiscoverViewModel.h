//
//  YDDiscoverViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDDiscoverViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *data;

- (void)reloadDataSource:(void (^)(void))completion;

@end

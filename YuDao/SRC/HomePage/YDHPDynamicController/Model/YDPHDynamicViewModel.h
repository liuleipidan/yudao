//
//  YDPHDynamicViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDDynamicModel.h"

@interface YDPHDynamicViewModel : NSObject

@property (nonatomic, strong) NSArray *dynamics;

- (void)requsetHomePageDynamicsCompletion:(void (^)(NSArray *dynamics))completion;

@end

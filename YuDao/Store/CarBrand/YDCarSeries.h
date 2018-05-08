//
//  YDCarSeries.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDCarModelProtocol.h"

@interface YDCarSeries : NSObject<YDCarModelProtocol>

@property (nonatomic, strong) NSNumber *vs_id;

@property (nonatomic, copy  ) NSString *vs_name;

@property (nonatomic, copy  ) NSString *firstletter;

@end

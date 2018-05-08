//
//  YDTestAQICell.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestCell.h"

typedef NS_ENUM(NSInteger,YDTestAQICellState) {
    YDTestAQICellStateUnbound = 0,//未绑定设备
    YDTestAQICellStateBound,      //绑定了设备
    
};

@interface YDTestAQICell : YDTestCell

@property (nonatomic, assign) YDTestAQICellState state;

@property (nonatomic, assign) NSUInteger aqi;

@end

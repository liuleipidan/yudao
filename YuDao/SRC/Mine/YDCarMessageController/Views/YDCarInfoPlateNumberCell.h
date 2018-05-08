//
//  YDCarInfoPlateNumberCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTableViewSingleLineCell.h"
#import "YDCarInfoItem.h"

@interface YDCarInfoPlateNumberCell : YDTableViewSingleLineCell

//车牌头
@property (nonatomic, copy, readonly) NSString *prefix;

//车牌号
@property (nonatomic, copy, readonly) NSString *plateNumber;

@property (nonatomic, strong) YDCarInfoItem *item;

@end

//
//  YDCarInfoCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/17.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTableViewSingleLineCell.h"
#import "YDCarInfoItem.h"

@interface YDCarInfoCell : YDTableViewSingleLineCell

@property (nonatomic, strong) YDCarInfoItem *item;

@end
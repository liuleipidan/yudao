//
//  YDCarIllegalityController.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/18.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDCarIllegalityCell.h"

@interface YDCarIllegalityController : YDViewController

/**
 车辆id
 */
@property (nonatomic, strong) NSNumber *ug_id;

@property (nonatomic, strong) NSArray<YDIllegalModel *> *data;

@end

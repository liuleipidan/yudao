//
//  YDDynamicLikerViewController.h
//  YuDao
//
//  Created by 汪杰 on 2017/4/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDTableViewController.h"

@class YDTapLikeModel;
@interface YDDynamicLikerViewController : YDTableViewController

@property (nonatomic, strong) NSArray<YDTapLikeModel *> *data;

@end

//
//  YDLikePersonController.h
//  YuDao
//
//  Created by 汪杰 on 16/11/3.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDTableViewController.h"
#import "YDLikePersonModel.h"

@interface YDLikePersonController : YDTableViewController

@property (nonatomic, strong) NSMutableArray<YDLikePersonModel *> *data;

@property (nonatomic, assign) YDLikedPeopleType likedType;

@end

//
//  YDRegisterController.h
//  YuDao
//
//  Created by 汪杰 on 16/11/17.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDViewController.h"

@interface YDRegisterController : YDViewController

@property (nonatomic, strong)  NSString *account;

@property (copy,nonatomic,readwrite) void(^RegisterBlock)(NSString * acount);

@end

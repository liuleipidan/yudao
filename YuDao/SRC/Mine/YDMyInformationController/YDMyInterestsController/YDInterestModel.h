//
//  YDInterestModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/10.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDInterest;
@interface YDInterestModel : NSObject

@property (nonatomic, assign) NSNumber *t_id;   //当前id
@property (nonatomic, copy  ) NSString *t_name;
@property (nonatomic, assign) NSNumber *t_pid; //父级id
@property (nonatomic, assign) NSNumber *t_time;

/**
 父级
 */
@property (nonatomic, strong) YDInterest *p_model;

/**
 子级数组
 */
@property (nonatomic, strong) NSMutableArray<YDInterest *> *interests;

/**
 已选数组
 */
@property (nonatomic, strong) NSMutableArray<YDInterest *> *selectedInterests;

//********** UI *************
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, copy  ) NSString *iconPath;

@end

@interface YDInterest : NSObject

@property (nonatomic, assign) NSNumber *t_id;   //当前id
@property (nonatomic, copy  ) NSString *t_name; //兴趣名
@property (nonatomic, assign) NSNumber *t_pid;  //父级id

@end

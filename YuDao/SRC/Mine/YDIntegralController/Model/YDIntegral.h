//
//  YDIntegral.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDIntegral : NSObject

//积分
@property (nonatomic, strong) NSNumber *c_credit;

//1 登录 2 任务  3商城返利 4 活动
@property (nonatomic, strong) NSNumber *c_type;

//1 加积分 0 减积分
@property (nonatomic, copy  ) NSString *c_modified;

//备注
@property (nonatomic, copy  ) NSString *c_content;

//时间（10位时间戳）
@property (nonatomic, strong) NSNumber *c_time;

@end

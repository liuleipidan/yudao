//
//  YDTaskModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/25.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 任务解析模型
 */
@interface YDTaskModel : NSObject

/**
 *  任务id
 */
@property (nonatomic, strong) NSNumber *t_id;
/**
 *  任务标题
 */
@property (nonatomic, copy  ) NSString *t_title;
/**
 *  任务介绍
 */
@property (nonatomic, copy  ) NSString *t_content;
/**
 *  任务奖励
 */
@property (nonatomic, strong) NSNumber *t_reward;
/**
 *  任务开始时间
 */
@property (nonatomic, copy  ) NSString *t_starttime;
/**
 *  任务结束时间
 */
@property (nonatomic, copy  ) NSString *t_endtime;
/**
 *  任务背景图片
 */
@property (nonatomic, copy  ) NSString *t_back_ground;

@end

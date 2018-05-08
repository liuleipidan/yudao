//
//  YDDynamicMessage.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/30.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDDynamicMessage : NSObject

#pragma mark - 点赞或评论的动态信息
/**
 动态id
 */
@property (nonatomic, strong) NSNumber *d_id;

/**
 动态标签
 */
@property (nonatomic, copy  ) NSString *d_label;

/**
 动态的第一张图片
 */
@property (nonatomic, copy  ) NSString *d_image;

/**
 动态内容
 */
@property (nonatomic, copy  ) NSString *d_details;

/**
 动态地址
 */
@property (nonatomic, copy  ) NSString *d_address;

#pragma mark - 点赞或评论的用户信息
/**
 用户id
 */
@property (nonatomic, copy  ) NSNumber *ub_id;

/**
 用户头像
 */
@property (nonatomic, copy  ) NSString *ud_face;

/**
 用户昵称
 */
@property (nonatomic, copy  ) NSString *nickName;

#pragma mark - 评论或点赞的信息

/**
 类型（1->评论, 2->点赞）
 */
@property (nonatomic, strong) NSNumber *type;

/**
 存在状态（1 正常 0 软删除）
 */
@property (nonatomic, strong) NSNumber *status;

/**
 评论内容，点赞时为nil
 */
@property (nonatomic, copy  ) NSString *conmentContent;



@end

//
//  YDDynamicModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/11.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDDynamicModel : NSObject

/**
 *  动态id
 */
@property (nonatomic, strong) NSNumber *d_id;

//动态类型
@property (nonatomic, strong) NSNumber *d_type;

/**
 *  动态内容
 */
@property (nonatomic, copy  ) NSString *d_details;
/**
 *  标签
 */
@property (nonatomic, copy  ) NSString *d_label;
/**
 *  用户id
 */
@property (nonatomic, strong  ) NSNumber *ub_id;
/**
 *  图片
 */
@property (nonatomic, copy  ) NSString *d_image;
/**
 *  地址
 */
@property (nonatomic, copy  ) NSString *d_address;
/**
 *  地址经纬度
 */
@property (nonatomic, copy  ) NSString *d_location;
/**
 *  是否显示位置，1->隐藏，其他显示
 */
@property (nonatomic, strong) NSNumber *d_hide;

/**
 *  查看人数
 */
@property (nonatomic, strong) NSNumber *d_look;
/**
 *  发布时间
 */
@property (nonatomic, copy  ) NSString *d_issuetime;
/**
 *  发布时间(新)
 */
@property (nonatomic, strong) NSNumber *d_issuetimeInt;
/**
 *  用户头像
 */
@property (nonatomic, copy  ) NSString *ud_face;
/**
 *  用户名
 */
@property (nonatomic, copy  ) NSString *u_name;
/**
 *  认证等级
 */
@property (nonatomic, strong) NSNumber *userauth;

#pragma mark - UI

@property (nonatomic, copy  ) NSString *imageUrl;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat cellHeight;

@end

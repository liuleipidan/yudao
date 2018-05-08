//
//  YDCard.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDCard : NSObject

/**
 卡券id
 */
@property (nonatomic, strong) NSNumber *couponId;

/**
 供应商
 */
@property (nonatomic, copy  ) NSString *provider;

/**
 卡密
 */
@property (nonatomic, copy  ) NSString *secret;

/**
 卡券状态
 */
@property (nonatomic, strong) NSNumber *status;

/**
 卡券状态图片路径
 */
@property (nonatomic, copy, readonly) NSString *statusIconPath;

/**
 卡券类型
 */
@property (nonatomic, strong) NSNumber *category;

/**
 类型标题，由category而来
 */
@property (nonatomic, copy, readonly) NSString *typeTitle;

/**
 卡券名字
 */
@property (nonatomic, copy  ) NSString *name;

/**
 开始时间
 */
@property (nonatomic, strong) NSNumber *startTime;

/**
 结束时间
 */
@property (nonatomic, strong) NSNumber *endTime;


/**
 时间限制条件，0永久有效，1指定日期，2有效期限
 */
@property (nonatomic, strong) NSNumber *expires;

/**
 是否已经过期，以endTime为准
 */
@property (nonatomic, assign, readonly) BOOL isExpired;

//-----------------------   封面处理   ------------------------
/**
 封面
 */
@property (nonatomic, copy  ) NSString *img;

/**
 封面链接
 */
@property (nonatomic, copy  ) NSString *imageURL;

/**
 封面宽
 */
@property (nonatomic,assign) CGFloat imageWidth;

/**
 封面高
 */
@property (nonatomic,assign) CGFloat imageHeight;
//-----------------------------------------------------------

/**
 使用车系
 */
@property (nonatomic, copy  ) NSString *apply;

/**
 使用须知,html字符串
 */
@property (nonatomic, copy  ) NSString *desc;

@end

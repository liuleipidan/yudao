//
//  YDActivityViewModel.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kShareActivityURL @"http://%@/app-share/activeDetails.html?aid=%@&fromApp=0"

@class YDActivity,YDActivityDetails;
@interface YDActivityViewModel : NSObject

/**
 当前页码
 */
@property (nonatomic, assign) NSUInteger pageIndex;

/**
 每页数量
 */
@property (nonatomic, assign) NSUInteger pageSize;

@property (nonatomic, strong) NSMutableArray *activityList;

- (void)requestActivityListWithSuccess:(void (^)(NSArray<YDActivity *> *data,BOOL hasMore))success
                               failure:(void (^)(NSNumber *code,NSString *status))failure;

+ (void)requestActivityDetailsWithActivityId:(NSNumber *)aid
                                     success:(void (^)(YDActivityDetails *activityDetails))success
                                     failure:(void (^)(NSNumber *code,NSString *status))failure;

+ (void)requestJoinActivityWithPara:(id )para
                            success:(void (^)(void))success
                            failure:(void (^)(NSNumber *code,NSString *status))failure;

@end

@interface YDActivity : NSObject

/**
 活动id
 */
@property (nonatomic, strong) NSNumber *aid;

/**
 类型，1->报名活动,2->积分商城,3->外部链接,4->预热活动
 */
@property (nonatomic, strong) NSNumber *type;

/**
 标题
 */
@property (nonatomic, copy  ) NSString *title;

/**
 活动头图
 */
@property (nonatomic, copy  ) NSString *img_url;

/**
 开始时间
 */
@property (nonatomic, strong) NSString *start_date;

/**
 结束时间
 */
@property (nonatomic, copy  ) NSString *end_date;

/**
 分享次数
 */
@property (nonatomic, strong) NSNumber *f_num;

/**
 查看次数
 */
@property (nonatomic, strong) NSNumber *l_num;

/**
 参数人数
 */
@property (nonatomic, strong) NSNumber *j_num;

/**
 预热人数，ps：这个其实是可以不要的字段
 */
@property (nonatomic, strong) NSNumber *preheat_num;

/**
 转成字符串,xx人已参加
 */
@property (nonatomic, copy  ) NSString *joinString;

/**
 活动类型网址参数 （如果是积分商城是商品id ，如果是报名活动为空）
 */
@property (nonatomic, copy  ) NSString *type_url;

@end

@interface YDActivityDetails : NSObject

/**
 活动id
 */
@property (nonatomic, strong) NSNumber *aid;

/**
 是否已经参加此活动
 */
@property (nonatomic, strong) NSNumber *status;

/**
 标题
 */
@property (nonatomic, copy  ) NSString *title;

/**
 活动头图
 */
@property (nonatomic, copy  ) NSString *img_url;

/**
 等级限制
 */
@property (nonatomic, strong) NSNumber *level;

/**
 性别限制
 */
@property (nonatomic, strong) NSNumber *mem_sex;

/**
 开始时间
 */
@property (nonatomic, copy  ) NSString *start_date;

/**
 结束时间
 */
@property (nonatomic, copy  ) NSString *end_date;

/**
 内容
 */
@property (nonatomic, copy  ) NSString *active_con;

@property (nonatomic, strong) NSNumber *f_num;
@property (nonatomic, strong) NSNumber *l_num;
@property (nonatomic, strong) NSNumber *j_num;

/**
 发布时间
 */
@property (nonatomic, copy  ) NSString *release_at;

@end

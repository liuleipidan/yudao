//
//  YDRingListModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/29.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDListModel : NSObject

@property (nonatomic, strong) NSNumber *ub_id;
@property (nonatomic, strong) NSString *ub_nickname;
@property (nonatomic, strong) NSNumber *ub_auth_grade;//认证等级
@property (nonatomic, strong) NSString *ud_face;    //头像
@property (nonatomic, strong) NSString *ud_location;

@property (nonatomic, strong) NSNumber *ud_age;
@property (nonatomic, strong) NSNumber *ud_sex;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *ud_tag_name;
@property (nonatomic, strong) NSNumber *ud_userauth;//是否认证
@property (nonatomic, copy  ) NSString *ud_constellation;//星座
@property (nonatomic, strong) NSNumber *ud_age_display;
@property (nonatomic, strong) NSNumber *ud_credit;  //积分

@property (nonatomic, strong) NSNumber *enjoy;      //是否已喜欢(1->可喜欢,2->已喜欢)

@property (nonatomic, strong) NSNumber *taplike;    //是否已点赞(1->可点赞,2->已点赞)

@property (nonatomic, strong) NSNumber *ranking;//排行榜标识字段

/*        里程       */
@property (nonatomic, strong) NSNumber *oti_mileage;//里程数  浮点型

/*        时速       */
@property (nonatomic, strong) NSNumber *oti_speed;//最高时速
@property (nonatomic, strong) NSNumber *oti_acceleration;//急加速
@property (nonatomic, strong) NSNumber *oti_brake;//急刹车
@property (nonatomic, strong) NSNumber *oti_turn;//急转弯

/*        油耗       */
@property (nonatomic, strong) NSNumber *oti_oilwear;//油耗（升）浮点型

/*        滞留       */
@property (nonatomic, strong) NSNumber *oti_stranded;//滞留(分钟)

/*        积分       */
//同基类

/*        喜欢       */
@property (nonatomic, strong) NSNumber *enjoynum;//喜欢人数

+ (NSString *)rankingImageByRank:(NSInteger )rank;

@end

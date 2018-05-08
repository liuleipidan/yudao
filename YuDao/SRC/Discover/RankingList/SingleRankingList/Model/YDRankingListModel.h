//
//  YDRankingListModel.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDRankingListModel : NSObject

//排行榜数据类型
@property (nonatomic, assign) YDRankingListDataType type;

#pragma mark - 用户基本信息
//用户id
@property (nonatomic, strong) NSNumber *ub_id;
//用户昵称
@property (nonatomic, strong) NSString *ub_nickname;
//用户等级
@property (nonatomic, strong) NSNumber *ub_auth_grade;
//头像链接
@property (nonatomic, strong) NSString *ud_face;
//经纬度（由app上传所得）
@property (nonatomic, strong) NSString *ud_location;
//年龄
@property (nonatomic, strong) NSNumber *ud_age;
//性别
@property (nonatomic, strong) NSNumber *ud_sex;
//兴趣
@property (nonatomic, strong) NSString *ud_tag_name;
//是否认真
@property (nonatomic, strong) NSNumber *ud_userauth;
//星座
@property (nonatomic, copy  ) NSString *ud_constellation;
//是否显示年龄
@property (nonatomic, strong) NSNumber *ud_age_display;
//省（直辖市）
@property (nonatomic, copy  ) NSString *ud_often_province_name;
//市
@property (nonatomic, copy  ) NSString *ud_often_city_name;

#pragma mark - 当前用户相关
//是否已喜欢(1->可喜欢,2->已喜欢)
@property (nonatomic, strong) NSNumber *enjoy;
//是否已点赞(1->可点赞,2->已点赞)
@property (nonatomic, strong) NSNumber *taplike;
//排行榜标识字段，存在时表示为当前用户的排行榜数据
@property (nonatomic, strong) NSNumber *ranking;

#pragma mark - 数据相关
//点赞数量
@property (nonatomic, strong) NSNumber *likenum;

//积分
@property (nonatomic, strong) NSNumber *ud_credit;

//里程
@property (nonatomic, strong) NSNumber *oti_mileage;//里程数  浮点型

//最高时速
@property (nonatomic, strong) NSNumber *oti_speed;

//急加速
@property (nonatomic, strong) NSNumber *oti_acceleration;

//急刹车
@property (nonatomic, strong) NSNumber *oti_brake;

//急转弯
@property (nonatomic, strong) NSNumber *oti_turn;

//油耗（升）浮点型
@property (nonatomic, strong) NSNumber *oti_oilwear;

//滞留(分钟)
@property (nonatomic, strong) NSNumber *oti_stranded;

//喜欢人数
@property (nonatomic, strong) NSNumber *enjoynum;

#pragma mark - UI
//排名文字
@property (nonatomic, copy  ) NSString *rankingText;

//排行榜icon，前三对应不同icon，其他暂无
@property (nonatomic, copy  ) NSString *rankingIconPath;

//地址（由省/市转化）
@property (nonatomic, copy  ) NSString *address;

//数据
@property (nonatomic, copy  ) NSString *dataString;

+ (YDRankingListModel *)createRankingModelByType:(YDRankingListDataType )type;


@end

//
//  YDUser.h
//  YuDao
//
//  Created by 汪杰 on 16/10/20.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YDUser : NSObject

//数据访问码
@property (nonatomic, copy  ) NSString    *access_token;

//用户id
@property (nonatomic, strong) NSNumber    *ub_id;

//用户名
@property (nonatomic, copy  ) NSString    *ub_name;

//昵称
@property (nonatomic, copy  ) NSString    *ub_nickname;

//真实姓名
@property (nonatomic, copy  ) NSString    *ud_realname;

//手机号
@property (nonatomic, copy  ) NSString    *ub_cellphone;

//密码，用于登录openfire
@property (nonatomic, copy  ) NSString    *ub_password;

//头像链接
@property (nonatomic, copy  ) NSString    *ud_face;

//下载后缓存里的图像
@property (nonatomic, strong) UIImage     *avatar;

//用户背景链接
@property (nonatomic, copy  ) NSString    *ud_background;

//---------------------------------------------------------------------
#pragma mark - 常出没地点（省、市、区）
//省Id
@property (nonatomic, strong) NSNumber    *ud_often_province;
//省名称
@property (nonatomic, copy  ) NSString    *ud_often_province_name;
//市Id
@property (nonatomic, strong) NSNumber    *ud_often_city;
//市名称
@property (nonatomic, copy  ) NSString    *ud_often_city_name;
//区Id
@property (nonatomic, strong) NSNumber    *ud_often_area;
//区名称
@property (nonatomic, copy  ) NSString    *ud_often_area_name;

//常出没地，用于“我的资料”
@property (nonatomic, copy, readonly) NSString    *oftenPlace;

//常出没地1，用于“我”模块主界面，不带市
@property (nonatomic, copy, readonly) NSString    *oftenPlace_1;

//---------------------------------------------------------------------
#pragma mark - 用户兴趣,逗号隔开
//兴趣父id
@property (nonatomic, copy  ) NSString    *ud_ftag;
//兴趣子id
@property (nonatomic, copy  ) NSString    *ud_tag;
//兴趣
@property (nonatomic, copy  ) NSString    *ud_tag_name;

//坐标
@property (nonatomic, copy  ) NSString    *ud_location;

//---------------------------------------------------------------------
#pragma mark - 认证相关
//身份证/驾驶证 正面
@property (nonatomic, copy  ) NSString    *ud_positive;

//身份证/驾驶证 反面
@property (nonatomic, copy  ) NSString    *ud_negative;

//用户认证等级
@property (nonatomic, strong) NSNumber    *ub_auth_grade;

//用户认证状态（0未认证 1已认证 2认证中 3认证失败）
@property (nonatomic, strong) NSNumber    *ud_userauth;

//认证字符串，用于UI显示
@property (nonatomic, copy  ) NSString    *authString;

//---------------------------------------------------------------------
#pragma mark - 年龄相关
//年龄
@property (nonatomic, strong) NSNumber    *ud_age;

//出生年月日，10位时间戳
@property (nonatomic, strong) NSNumber    *ud_birth;

//星座
@property (nonatomic, copy  ) NSString    *ud_constellation;

//性别(1男，2女)
@property (nonatomic, strong) NSNumber    *ud_sex;

//情感状态
@property (nonatomic, strong) NSNumber    *ud_emotion;

//情感状态字符串，用于ui显示
@property (nonatomic, copy  ) NSString    *emotionString;

@property (nonatomic, strong) NSNumber    *ud_age_display;

//被喜欢的人数
@property (nonatomic, strong) NSNumber    *likeNum;

//用户积分
@property (nonatomic, strong) NSNumber    *ud_credit;


/**
 获取用于中间转换数据的用户对象
 */
- (YDUser *)getTempUserData;

/**
 比较用户可修改的信息

 @param user 将要修改的用户对象
 @return 是否一样
 */
- (BOOL)compareUserCanChangeInformation:(YDUser *)user;

@end

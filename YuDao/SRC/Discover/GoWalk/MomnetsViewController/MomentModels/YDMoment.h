//
//  YDMoment.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDMomentFrame.h"

//分区间距
#define SPACE_MOMENT_ZONE 10.0f
//头部视图高度
#define HEIGHT_MOMENT_HEADER_DEFAULT SPACE_MOMENT_ZONE + 50.f
//图片容器高度
#define HEIGHT_MOMENT_IMAGES_DEFAULT SCREEN_WIDTH - SPACE_MOMENT_ZONE
//视频容器高度
#define HEIGHT_MOMENT_VIDEO_DEFAULT  (SCREEN_WIDTH - SPACE_MOMENT_ZONE) * 0.563
//底部视图高度
#define HEIGHT_MOMENT_BOTTOM_DEFAULT SPACE_MOMENT_ZONE + 56.f

#define UILABEL_LINE_SPACE 6

@interface YDMoment : NSObject

@property (nonatomic, strong) YDMomentFrame *frame;

/**
 动态id
 */
@property (nonatomic, strong) NSNumber *d_id;

/**
 动态类型，0->文字,1->图片,2->视频
 */
@property (nonatomic, strong) NSNumber *d_type;

/**
 用户id
 */
@property (nonatomic, strong) NSNumber *ub_id;

/**
 用户名
 */
@property (nonatomic, copy  ) NSString *ub_nickname;

/**
 性别
 */
@property (nonatomic, strong) NSNumber *ud_sex;

/**
 等级
 */
@property (nonatomic, strong) NSNumber *ub_auth_grade;

/**
 头像URL
 */
@property (nonatomic, copy  ) NSString *ud_face;

/**
 认证等级
 */
@property (nonatomic, strong) NSNumber *ud_userauth;

/**
 是否点赞:1 -> 否 2 -> 是
 */
@property (nonatomic, strong) NSNumber *state;

/**
 是否为好友:1 -> 否 2 -> 是
 */
@property (nonatomic, strong) NSNumber *friend;

/**
 动态内容
 */
@property (nonatomic, copy  ) NSString *d_details;

/**
 带有行高的属性字符串
 */
@property (nonatomic, copy  ) NSMutableAttributedString *attrContent;

/**
 标签
 */
@property (nonatomic, copy  ) NSString *d_label;

/**
 图片全部信息数组：字符串，包括图片的路径、宽和高，由“,”隔开
 */
@property (nonatomic, strong) NSArray *d_image;

/**
 拆解d_image，解出纯图片路径的数组
 */
@property (nonatomic, strong) NSArray *imagesURL;

/**
 视频网址
 */
@property (nonatomic, copy  ) NSString *d_video;

/**
 位置信息
 */
@property (nonatomic, copy  ) NSString *d_address;

/**
 此动态是否隐藏位置：0 -> 否 1 -> 是
 */
@property (nonatomic, strong) NSNumber *d_hide;

/**
 坐标（经纬度）
 */
@property (nonatomic, copy  ) NSString *d_location;

/**
 发布时间
 */
@property (nonatomic, copy  ) NSString *d_issuetime;

/**
 发布时间(新)
 */
@property (nonatomic, strong) NSNumber *d_issuetimeInt;

/**
 时间
 */
@property (nonatomic, copy  ) NSString *d_time;

/**
 UI显示时间
 */
@property (nonatomic, copy  ) NSString *showTime;

/**
 喜欢此动态的人数
 */
@property (nonatomic, strong) NSNumber *taplikenum;

/**
 评论此动态的人数
 */
@property (nonatomic, strong) NSNumber *commentnum;

@end

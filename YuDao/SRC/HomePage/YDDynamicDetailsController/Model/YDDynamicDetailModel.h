//
//  YDDynamicDetailModel.h
//  YuDao
//
//  Created by 汪杰 on 16/11/24.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  动态详情模型
 */
@interface YDDynamicDetailModel : NSObject

//动态id
@property (nonatomic, strong) NSNumber *d_id;

//动态拥有者id
@property (nonatomic, strong) NSNumber *ub_id;

//动态类型，0->文字,1->图片,2->视频
@property (nonatomic, strong) NSNumber *d_type;

//动态内容
@property (nonatomic, copy) NSString *d_details;

//动态标签
@property (nonatomic, strong) NSString *d_label;

//图片URL数组
@property (nonatomic, strong) NSArray *d_image;

//视频链接
@property (nonatomic, copy  ) NSString *d_video;

//地址
@property (nonatomic, strong) NSString *d_address;

//是否显示位置，1隐藏，0显示
@property (nonatomic, strong) NSNumber *d_hide;

//经纬度
@property (nonatomic, strong) NSString *d_location;

//查看次数
@property (nonatomic, strong) NSNumber *d_look;

//发布时间
@property (nonatomic, copy  ) NSString *d_issuetime;

//发布时间(新)
@property (nonatomic, strong) NSNumber *d_issuetimeInt;

@property (nonatomic, strong) NSString *d_time;

//昵称
@property (nonatomic, strong) NSString *ub_nickname;

//性别
@property (nonatomic, strong) NSNumber *ud_sex;

//认证等级
@property (nonatomic, strong) NSNumber *ub_auth_grade;

//头像链接
@property (nonatomic, strong) NSString *ud_face;

//-----------  Array  --------------------------
//点赞用户数组
@property (nonatomic, strong) NSMutableArray *taplike;

//评论动态数组
@property (nonatomic, strong) NSMutableArray *commentdynamic;

//-----------  UI  --------------------------
@property (nonatomic, assign) CGFloat contentHeight;

//属性字符串
@property (nonatomic, strong) NSMutableAttributedString *contentAttr;
//标签宽度
@property (nonatomic, assign) CGFloat labelWidth;
//图片数据
@property (nonatomic, strong) NSArray<NSDictionary *> *imagesDicArray;
//图片高度
@property (nonatomic, assign) CGFloat imagesHeight;
//视频高度
@property (nonatomic, assign) CGFloat videoHeight;
//位置高度
@property (nonatomic, assign, readonly) CGFloat locationHeight;
//喜欢的人高度
@property (nonatomic, assign, readonly) CGFloat likerHeight;

@end

/**
 *  动态点赞模型
 */
@interface YDTapLikeModel : NSObject

//主键
@property (nonatomic, strong) NSNumber *tl_id;
//动态id
@property (nonatomic, strong) NSNumber *d_id;
//用户id
@property (nonatomic, strong) NSNumber *ub_id;
//用户昵称
@property (nonatomic, copy  ) NSString *ub_nickname;
//类型
@property (nonatomic, strong) NSNumber *tl_type;
//时间
@property (nonatomic, strong) NSString *tl_time;
//时间(新)
@property (nonatomic, strong) NSNumber *tl_timeint;
//头像链接
@property (nonatomic, strong) NSString *ud_face;

//-----------  UI  --------------------------
/**
 用于展示的时间
 */
@property (nonatomic, copy  ) NSString *showTime;


@end

/**
 *  动态评论模型
 */
@interface YDDynamicCommentModel : NSObject

//主键
@property (nonatomic, strong) NSNumber *cd_id;
//评论父id
@property (nonatomic, strong) NSNumber *cd_pid;
//动态id
@property (nonatomic, strong) NSNumber *d_id;
//用户id
@property (nonatomic, strong) NSNumber *ub_id;
//用户昵称
@property (nonatomic, strong) NSString *ub_nickname;
//用户头像链接
@property (nonatomic, strong) NSString *ud_face;
//评论时间
@property (nonatomic, strong) NSNumber *cd_dateInt;

//评论内容
@property (nonatomic, strong) NSString *cd_details;

//-----------  UI  --------------------------
@property (nonatomic, copy  ) NSAttributedString *detailsAttr;

@property (nonatomic, assign) CGFloat textHeight;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy  ) NSString *timeInfo;

@end


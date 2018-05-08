//
//  YDApiURLs.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/4.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDApiURLs_h
#define YDApiURLs_h

//获取验证码
#define kSmsURL [kOriginalURL stringByAppendingString:@"sms"]

//每日登陆
#define kDailyLoginURL [kOriginalURL stringByAppendingString:@"dailylogin"]

//分享
#define kActicitySharedURL [kOriginalURL stringByAppendingString:@"activitysharenum"]

//第三方登录是否绑定过
#define kHadBindThirdPlatformURL [kOriginalURL stringByAppendingString:@"judgeexternal"]

//绑定第三方帐号id
#define kBindThirdPlatformURL [kOriginalURL stringByAppendingString:@"external"]

//上传动态图片
#define kCommitDynamicImageURL [kOriginalURL stringByAppendingString:@"dynamicfile"]

//动态热门标签
#define kDynamicHotLabelsURL [kOriginalURL stringByAppendingString:@"populartags"]

//用户信息（只需传access_token,用户更新当前用户的信息）
#define kUserInfoURL [kOriginalURL stringByAppendingString:@"memberinfo"]

//发布动态
#define kAddDynamicURL [kOriginalURL stringByAppendingString:@"adddynamic"]

//所有排行榜数据
#define kAllRankinglistURL [kOriginalURL stringByAppendingString:@"runranking"]

//评论动态
#define kAddcommentdynamicURL [kOriginalURL stringByAppendingString:@"addcommentdynamic"]

//删除评论
#define kDeleteCommentURL     [kOriginalURL stringByAppendingString:@"delecommentdynamic"]

//上传用户认证
#define kUpuploadUserImageURL [kOriginalURL stringByAppendingString:@"userauth"]

//访客
#define kVisitorsURL [kOriginalURL stringByAppendingString:@"getvistor"]

//上传车辆认证
#define kUpuploadCarCardImageURL [kOriginalURL stringByAppendingString:@"authvehicle"]

//动态
#define kDynamicDataURL [kOriginalURL stringByAppendingString:@"dynamic"]

//动态举报
#define kDynamicReportURL [kOriginalURL stringByAppendingString:@"reportdynamic"]

//添加好友
#define kAddFriendURL [kOriginalURL stringByAppendingString:@"addfriend"]

//添加好友
#define kSendGiftURL [kOriginalURL stringByAppendingString:@"gifts"]

//上传通讯录手机号
#define kUploadPhoneContactsURL [kOriginalURL stringByAppendingString:@"contacts"]

//删除动态
#define kDeleteDynamicURL [kOriginalURL stringByAppendingString:@"deledynamic"]

//动态数据
#define kDynamicURL [kOriginalURL stringByAppendingString:@"dynamic"]

//所有推送消息
#define kPushMessageURL [kOriginalURL stringByAppendingString:@"messagedata"]

//首页推送消息
#define kHomePageMessageURL [kOriginalURL stringByAppendingString:@"homemessage"]

//动态消息数量
#define kDynamicMessagesCountURL [kOriginalURL stringByAppendingString:@"dmcount"]

//动态消息
#define kDynamicMessagesURL [kOriginalURL stringByAppendingString:@"dynamicmessage"]

//发送聊天消息推送
#define kSendChatNofiticationURL [kOriginalURL stringByAppendingString:@"chatmessage"]

//上传用户头像
#define kUploadUserHeaderImageURL [kOriginalURL stringByAppendingString:@"upavatar"]

//省市区
#define kPlaceURL  [kOriginalURL stringByAppendingString:@"china"]

//刷脸
#define kSlipFaceUrl [kOriginalURL stringByAppendingString:@"faceswiping"]

//不喜欢
#define kDislikeUserURL [kOriginalURL stringByAppendingString:@"dislike"]

//**************** 活动 ********************
//获取活动列表
#define kActivityListURL [kOriginalURL stringByAppendingString:@"getactiveall"]

//活动详情
#define kActivityDetailsURL [kOriginalURL stringByAppendingString:@"getactivedetails"]

//参加活动
#define kActivityJoinURL [kOriginalURL stringByAppendingString:@"joinactive"]

//逛一逛数据
#define kGowalkURL [kOriginalURL stringByAppendingString:@"walk"]

//动态详情
#define kDynamicDetailURL [kOriginalURL stringByAppendingString:@"dynamicdetails"]

//删除车辆
#define kDeleteCar [kOriginalURL stringByAppendingString:@"delvehicle"]

//点击喜欢动态
#define kAddLikedynamicURL    [kOriginalURL stringByAppendingString:@"addlike"]

//点击喜欢人
#define kAddLikeUserURL    [kOriginalURL stringByAppendingString:@"addenjoy"]

//刷新token
#define kRefreshTokenURL [kOriginalURL stringByAppendingString:@"refresh-token"]

//修改用户背景
#define kChangeUserBackgroudImageURL [kOriginalURL stringByAppendingString:@"upbackground"]

//喜欢我的人数
#define kLikeMePersonsURL [kOriginalURL stringByAppendingString:@"enjoymy"]

//卡包数据
#define kCardPackageURL [kOriginalURL stringByAppendingString:@"getcouponlist"]

//卡券详情
#define kCardDetailsURL [kOriginalURL stringByAppendingString:@"getCouponDet"]

//用户首页忽略列表
#define kUserHPIgnoreListURL [kOriginalURL stringByAppendingString:@"homemodulelist"]

//添加需要忽略的模块
#define kAddUserHPIgnoreURL [kOriginalURL stringByAppendingString:@"homemodule"]

//删除需要忽略的模块
#define kDeleteUserHPIgnoreURL [kOriginalURL stringByAppendingString:@"deleneglect"]

//取消喜欢
#define kDeleteEnjoyUrl   [kOriginalURL stringByAppendingString:@"delenjoy"]

//其他用户档案
#define kOtherFilesURL   [kOriginalURL stringByAppendingString:@"othersfiles"]
//其他用户动态
#define kOtherDynamicURL [kOriginalURL stringByAppendingString:@"filedynamic"]

#pragma mark ------------------------ 车辆数据URL ------------------------------
//天气数据
#define kWeatherURL      [kOriginalURL stringByAppendingString:@"aweather"]

//检测数据
#define kTestDataURL     [kOriginalURL stringByAppendingString:@"obdhealthtesting"]

//车的位置
#define kCarLocationURL  [kOriginalURL stringByAppendingString:@"obdvehicledistance"]

//车辆列表
#define kCarsListURL     [kOriginalURL stringByAppendingString:@"vehiclelist"]

//获取邀请码
#define kOBDIvitationCode [kOriginalURL stringByAppendingString:@"getchannelid"]

//上传用户的位置
#define kUploadUserLocationUrl  [kOriginalURL stringByAppendingString:@"obtainloc"]

//上传用户推送信息
#define kBindJPushIDURL  [kOriginalURL stringByAppendingString:@"msgbound"]

//任务
#define kDownloadTaskURL [kOriginalURL stringByAppendingString:@"task"]

//用户任务(新接口)
#define kUserTaskURL [kOriginalURL stringByAppendingString:@"tasktwo"]

//车的位置
#define kSearchUserURL  [kOriginalURL stringByAppendingString:@"huut"]

//车辆详情
#define kCarDetailDataURL [kOriginalURL stringByAppendingString:@"vehicledeta"]

//修改车辆信息
#define kChangeCarDataURL [kOriginalURL stringByAppendingString:@"upvehicle"]

#endif /* YDApiURLs_h */

//
//  YDEnumerate.h
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#ifndef YDEnumerate_h
#define YDEnumerate_h

#import "YDEnumerateChat.h"
/**
 父级类型(1->行车信息,2->任务,3->消息,4->排行榜)
 消息包括（
 2001->周报,
 7000->天气,
 9003->卡券,
 9002->营销活动,
 9010->服务推送
 ）
 */
/**
 *  首页模块类型
 */
typedef NS_ENUM(NSInteger, YDHomePageModuleType) {
    YDHomePageModuleTypeUnknown = 0, //未知
    YDHomePageModuleTypeCarInfo = 1, //行车信息
    YDHomePageModuleTypeTask = 2,    //任务
    YDHomePageModuleTypeMessages = 3,//消息
    YDHomePageModuleTypeRankList = 4,//排行榜
};

/**
 *  逛一逛的控制器类型
 */
typedef NS_ENUM(NSInteger, YDGowalkViewControllerType) {
    YDGowalkViewControllerTypeNewest,
    YDGowalkViewControllerTypeNearby,
    YDGowalkViewControllerTypeFriend,
};

/**
 数据请求返回类型
 */
typedef NS_ENUM(NSInteger, YDRequestReturnDataType) {
    YDRequestReturnDataTypeSuccess = 0, //成功
    YDRequestReturnDataTypeFailure,     //失败
    YDRequestReturnDataTypeNULL,        //暂无此类数据
    YDRequestReturnDataTypeNomore,      //没有更多了
    YDRequestReturnDataTypeTimeout,      //超时
};

//认证状态
typedef NS_ENUM(NSInteger, YDAuthenticateStatus) {
    YDAuthenticateStatusNo = 0,    //未认证
    YDAuthenticateStatusSuccess,   //认证成功
    YDAuthenticateStatusAuthing,   //认证中
    YDAuthenticateStatusFail,      //认证失败
};

//喜欢的人类型
typedef NS_ENUM(NSInteger, YDLikedPeopleType) {
    YDLikedPeopleTypeLikeMe = 1,    // 喜欢我的
    YDLikedPeopleTypeILike,    // 我喜欢的
    YDLikedPeopleTypeEachLike,   // 互相喜欢的
};

//当前排行榜数据类型
typedef NS_ENUM(NSInteger, YDRankingListDataType){
    YDRankingListDataTypeNormal = 0, //默认
    YDRankingListDataTypeSpeed,      //时速
    YDRankingListDataTypeMileage,    //里程
    YDRankingListDataTypeOilwear,    //油耗
    YDRankingListDataTypeStop,       //滞留
    YDRankingListDataTypeScore,      //积分
    YDRankingListDataTypeLike,       //喜欢
};

//排行榜数据筛选条件
typedef NS_ENUM(NSInteger, YDRankingListFilterCondition){
    YDRankingListFilterConditionNo = 0, //默认，不限
    YDRankingListFilterConditionGirl,   //女生
    YDRankingListFilterConditionBoy,    //男生
    YDRankingListFilterConditionFriend, //好友
    YDRankingListFilterConditionNearby, //附近
    YDRankingListFilterConditionCar,    //车友
};

/**
 *  键盘控制器状态
 */
typedef NS_ENUM(NSInteger, YDKeyboardControlStatus) {
    YDKeyboardControlStatusInit = 0,
    YDKeyboardControlStatusSystem,
    YDKeyboardControlStatusEmoji,
};

/**
 *  分享的平台类型
 */
typedef NS_ENUM(NSInteger,YDClickSharePlatformType) {
    YDClickSharePlatformTypeWechat = 1,
    YDClickSharePlatformTypeWechatFriend,
    YDClickSharePlatformTypeQQFriend,
    YDClickSharePlatformTypeQQZone,
    YDClickSharePlatformTypeWeibo,
};

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, YDReachabilityStatus) {
    /**
     *  未知网络状态
     */
    YDReachabilityStatusUnknown = -1,
    /**
     *  无网络
     */
    YDReachabilityStatusNotReachable = 0,
    /**
     *  蜂窝数据网
     */
    YDReachabilityStatusWWAN = 1,
    /**
     *  WiFi网络
     */
    YDReachabilityStatusWiFi = 2,
};

/**
 *  会话提示类型
 */
typedef NS_ENUM(NSInteger, YDClueType) {
    YDClueTypeNone,
    YDClueTypePoint,
    YDClueTypePointWithNumber,
};

/**
 *  会话类型
 */
typedef NS_ENUM(NSInteger, YDConversationType) {
    YDConversationTypePersonal,     // 个人
    YDConversationTypeGroup,        // 群聊
    YDConversationTypePublic,       // 公众号
    YDConversationTypeServerGroup,  // 服务组（订阅号、企业号）
};

typedef NS_ENUM(NSInteger, YDMessageRemindType) {
    YDMessageRemindTypeNormal,    // 正常接受
    YDMessageRemindTypeClosed,    // 不提示
    YDMessageRemindTypeNotLook,   // 不看
    YDMessageRemindTypeUnlike,    // 不喜欢
};

/**
 *  系统消息类型
 */
typedef NS_ENUM(NSInteger, YDSystemMessageType) {
    YDSystemMessageTypeUnknown = -1, //未知
    YDSystemMessageTypeNormal = 0,   //默认格式
    YDSystemMessageTypeUser,         //用户
    YDSystemMessageTypeTextJump,     //可点击文本跳转
};

/**
 *  服务器消息类型
 */
typedef NS_ENUM(NSInteger,YDServerMessageType) {
    YDServerMessageTypeUnknown = -1, //未知
    
    YDServerMessageTypeChatMessage      = 1000, //聊天消息
    YDServerMessageTypeFriendRequest    = 1001, //好友请求
    YDServerMessageTypeFriendRefused    = 1002, //拒绝好友请求
    YDServerMessageTypeFriendDeleted    = 1003, //被对方删除
    YDServerMessageTypeGameUnopened     = 1005,  //游戏未开放
    YDServerMessageTypeLikedCurrentUser = 1010, //喜欢当前用户
    
    YDServerMessageTypeWeeklyReport     = 2001, //周报
    YDServerMessageTypeIllegal          = 2002, //车辆违章
    YDServerMessageTypeDynamicMessage   = 2003, //动态消息
    
    YDServerMessageTypeUserInvalid      = 3000, //用户已失效（token已经过期）
    YDServerMessageTypeTaskFinished     = 3001, //任务完成
    YDServerMessageTypeOtherDeviceLogin = 3002, //账号被顶
    
    YDServerMessageTypeDailyPush        = 4001, //每日推送
    
    YDServerMessageTypeAvatarVerify     = 5001, //头像审核
    YDServerMessageTypeBackgroundVerify = 5002,//背景审核
    YDServerMessageTypeIdentityAuth     = 5003, //身份认证
    YDServerMessageTypeCarAuth          = 5004, //车辆认证
    
    YDServerMessageTypeWeather          = 7000, //天气
    
    YDServerMessageTypeWechatPush       = 8001, //微信推送
    
    YDServerMessageTypeMessageNotification = 9001, //消息通知
    YDServerMessageTypeMarketingActivity   = 9002, //营销活动
    YDServerMessageTypeCouponSend          = 9003, //卡券发放
    YDServerMessageTypeAdviseFeedback      = 9004, //意见反馈
    YDServerMessageTypeIntegralChanged     = 9005, //积分变动
    YDServerMessageTypeServerPush          = 9010, //服务推送
    
    YDServerMessageTypeCarInforChanged = 10001,//车辆信息变动
    YDServerMessageTypeUserInfoChanged = 10002,//用户信息变动
};


/**
 *  "扫一扫"类型
 */
typedef NS_ENUM(NSUInteger, YDScannerType) {
    YDScannerTypeAll = 0,    //无限制
    YDScannerTypeQRUser,     //用户二维码
    YDScannerTypeQRVE_BOX,   //OBD二维码
    YDScannerTypeQRVE_Air,   //空静二维码
    YDScannerTypeQRDevice,   //设备二维码，即可扫描VE_BOX+VE_Air
    
};

/**
 *  "扫一扫"结果类型
 */
typedef NS_ENUM(NSInteger, YDScannerResultType) {
    YDScannerResultTypeUnknown = 0,     //未知
    YDScannerResultTypeUser = 1,        //用户
    YDScannerResultTypeHttp = 2,        //链接
    YDScannerResultTypeVE_BOX = 3,      //VE-BOX
    YDScannerResultTypeVE_AIR = 4,      //VE-AIR
};

/**
 *  设备类型
 */
typedef NS_ENUM(NSUInteger, YDBindDeviceType) {
    YDBindDeviceTypeUnknown = 0,    //未知
    YDBindDeviceTypeVE_BOX,         //VE-BOX
    YDBindDeviceTypeVE_AIR,         //VE-Air
    
};


/**
 *  车辆已经绑定的设备类型
 */
typedef NS_ENUM(NSInteger, YDCarBoundDeviceType) {
    YDCarBoundDeviceTypeNone = 0, //未绑定任何设备
    YDCarBoundDeviceTypeVE_BOX,   //只绑定了VE-BOX
    YDCarBoundDeviceTypeVE_AIR,   //只绑定了VE-AIR
    YDCarBoundDeviceTypeBOX_AIR,  //绑定了VE-BOX和VE-AIR
};

/**
 *  添加菜单的item类型
 */
typedef NS_ENUM(NSInteger, YDAddMneuType) {
    YDAddMneuTypeFilter = 0,
    YDAddMneuTypeShare,
};

#endif /* YDEnumerate_h */

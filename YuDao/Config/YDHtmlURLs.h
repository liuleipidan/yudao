//
//  YDHtmlURLs.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/4.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDHtmlURLs_h
#define YDHtmlURLs_h

//周报
#define kWeeklyReportHtmlURL @"http://%@/weekReport/index.html?access_token=%@&ug_id=%@&fromApp=%@&nickName=%@&carName=%@&uid=%@&versionCode=%@"

//未参加游戏URL
#define kGameNotJoinHtmlURL @"http://%@/game/index.html?access_token=%@&ug_id=%@&steps=%d&versionCode=%@"

//已参加游戏URL
#define kGameHadJoinHtmlURL @"http://%@/game/game.html?access_token=%@&ug_id=%@&steps=%d&versionCode=%@"

//活动详情网址
#define kActivityDetailsHtmlURL @"http://%@/app-share/activeDetails.html?aid=%@&fromApp=1&access_token=%@&nickName=%@&phone=%@&sex=%@&versionCode=%@"

//商城首页
#define kServiceHtmlURL @"http://mall.%@index.php?channelid=%@&uid=%@&versionCode=%@"

//订单
#define kOrdersHtmlURL  @"http://%@/order/order.html?uid=%@&versionCode=%@"

//用户协议
#define kUserProtocolHtmlURL @"http://%@/userAgreement/index.html?versionCode=%@"

#endif /* YDHtmlURLs_h */

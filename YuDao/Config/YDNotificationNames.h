//
//  YDNotificationNames.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDNotificationNames_h
#define YDNotificationNames_h

/********************  消息中心通知KEY  ************************/

#define kHPModuleHadChangeNotificatoin @"kHPModuleHadChangeNotificatoin"

//刷新通讯录数据
#define kUpdateContactsNotification      @"kChangeContactsNotification"

//通知刷新行车信息
#define kResetCarMessageNotifiaction     @"kResetCarMessageNotifiaction"

//搜索控制器将要显示
#define kSearchVCWillAppearNotification  @"kSearchVCWillAppearNotification"

///监控首页显示的模块，收到此通知则隐藏相应模块
#define kHomePageMonitorModelNotification @"kHomePageMonitorModelNotification"

//添加车辆
#define kHadAddedNewCarNotification  @"kHadAddedNewCarNotification"

//搜索结果tableView滑动
#define kSearchResultTableViewDidScrollNotification @"kSearchResultTableViewDidScrollNotification"

//分享成功
#define kActivitySharedSuccessfulNotification @"kActivitySharedSuccessfulNotification"

#endif /* YDNotificationNames_h */

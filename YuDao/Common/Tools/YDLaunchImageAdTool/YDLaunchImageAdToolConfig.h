//
//  YDLaunchImageAdToolConfig.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/1.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#ifndef YDLaunchImageAdToolConfig_h
#define YDLaunchImageAdToolConfig_h

//启动图的消失类型
typedef NS_ENUM(NSInteger,YDLaunchImageDismissType) {
    YDLaunchImageDismissTypeTimeout = 0, //超时
    YDLaunchImageDismissTypeClickImage,  //点击图片
    YDLaunchImageDismissTypeClickButton, //点击按钮
    YDLaunchImageDismissTypeNone,        //无启动图片
    YDLaunchImageDismissTypeFirstTime,   //初次获取到启动图片，不显示，只下载
};

typedef void(^YDLaunchImageDismissBlock)(YDLaunchImageDismissType dismissType);

static NSInteger kDefaultAdImageTime;

static NSTimeInterval const dismissDuration = 0.5f;

#pragma mark - NSUserDefaults - key - 用于本地缓存

//已有的启动图网址
#define kAlreadyHadLaunchImageURL @"kAlreadyHadLaunchImageURL"

//存当天第一显示时间
#define kAdImageFirstShowTime @"kAdImageFirstShowTime"

//存当天显示的次数
#define kAdImageDisplayTimes @"kAdImageDisplayTimes"


#endif /* YDLaunchImageAdToolConfig_h */

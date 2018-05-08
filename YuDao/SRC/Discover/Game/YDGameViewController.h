//
//  YDGameViewController.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/26.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

//游戏状态
typedef NS_ENUM(NSInteger,YDGameStatus) {
    YDGameStatusUnknown = 0, //未知
    YDGameStatusUnopened,    //未开放
    YDGameStatusNotJoin,     //未参加
    YDGameStatusHadJoin,     //已参加
    YDGameStatusCompletion,  //完成赛段
    YDGameStatusQuit,        //退出
};


@interface YDGameViewController : YDWKWebViewController

@end

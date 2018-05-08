//
//  UIColor+YuDao.h
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YuDao)

#pragma mark - 色值
+ (UIColor *)colorWithString:(NSString *)colorString;

#define YellowColor [UIColor colorWithString:@"#F8E71E"];
#define PurpleColor [UIColor colorWithString:@"#70449F"];

//基本色
#define     YDBaseColor [UIColor colorWithString:@"#2B3552"]
#define     YDColorString(string) [UIColor colorWithString:string]

#pragma mark - 基色
+ (UIColor *)baseColor;

#pragma mark - 文字

/**
 黑色字体，42，42，42，1
 */
+ (UIColor *)blackTextColor;

/**
 灰色字体，153，153，153，1
 */
+ (UIColor *)grayTextColor;

/**
 黑色字体，223，223，223，1
 */
+ (UIColor *)grayTextColor1;

/**
 橙色字体，255，153，115，1
 */
+ (UIColor *)orangeTextColor;

/**
 绿色字体，171,218,120,1
 */
+ (UIColor *)greenTextColor;

/**
 灰色单元格分割线，223，223，223，1
 */
+ (UIColor *)grayCellLineColor;

#pragma mark - 背景色
+ (UIColor *)tableViewSectionHeaderViewBackgoundColor;

#pragma mark - 阴影
/**
 阴影色，223，223，223，1
 */
+ (UIColor *)shadowColor;

//背景色
+ (UIColor *)grayBackgoundColor;

//搜索框背景色
+ (UIColor *)searchBarBackgroundColor;

#pragma mark - 分割线
+ (UIColor *)lineColor;
+ (UIColor *)lineColor1;

#pragma mark - # 字体
+ (UIColor *)colorTextBlack;
+ (UIColor *)colorTextGray;
+ (UIColor *)colorTextGray1;


#pragma mark - 灰色
+ (UIColor *)colorGrayBG;           // 浅灰色默认背景
+ (UIColor *)colorGrayCharcoalBG;   // 较深灰色背景（聊天窗口, 朋友圈用）
+ (UIColor *)colorGrayLine;
+ (UIColor *)colorGrayForChatBar;
+ (UIColor *)colorGrayForMoment;

#pragma mark - 绿色
+ (UIColor *)colorGreenDefault;


#pragma mark - 蓝色
+ (UIColor *)colorBlueMoment;


#pragma mark - 黑色
+ (UIColor *)colorBlackForNavBar;
+ (UIColor *)colorBlackBG;
+ (UIColor *)colorBlackAlphaScannerBG;
+ (UIColor *)colorBlackForAddMenu;
+ (UIColor *)colorBlackForAddMenuHL;

@end

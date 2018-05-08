//
//  YDMacros.h
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#ifndef YDMacros_h
#define YDMacros_h

#ifdef  DEBUG //测试
//#define YDString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
//#define YDLog(...) printf("%s 第%d行: %s\n\n",[YDString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#define YDLog(format, ...)  NSLog((@"FUNC:%s\n" "LINE:%d\n" format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else   //上线
#define YDLog(format, ...);
#endif

#pragma mark - App
//AppID(此id为appstore唯一标识符，用于更新app用)
#define kAppID            @"1197257950"
//AppStore访问链接前缀,结合kAppID可访问到appStore的本app
#define kAPPStoreURL      @"http://itunes.apple.com/cn/lookup?id="
//极光推送的注册码的key值
#define kRegistrationID   @"kRegistrationID"



#pragma mark - 系统版本
#define     SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define     SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define     SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define     SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_8_0 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

#pragma mark - 屏幕尺寸
#define     SCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define     SCREEN_WIDTH                SCREEN_SIZE.width
#define     SCREEN_HEIGHT               SCREEN_SIZE.height
#define     SCREEN_BOUNDS               [UIScreen mainScreen].bounds

#pragma mark - 设备(屏幕)类型
#define     IS_IPHONE4              (SCREEN_HEIGHT >= 480.0f)           // 320 * 480
#define     IS_IPHONE5              (SCREEN_HEIGHT >= 568.0f)           // 320 * 568
#define     IS_IPHONE6              (SCREEN_HEIGHT >= 667.0f)           // 375 * 667
#define     IS_IPHONE6P             (SCREEN_HEIGHT >= 736.0f)           // 414 * 736
#define     IS_IPHONEX              ([UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f)
#define     IS_IPad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? YES : NO

#pragma mark - 常用控件高度
#define     STATUSBAR_HEIGHT            (IS_IPHONEX ? 44.0f : 20.0f)
#define     TABBAR_HEIGHT               (IS_IPHONEX ? 49.0f + 34.0f : 49.0f)
#define     NAVBAR_HEIGHT               44.0f
#define     SEARCHBAR_HEIGHT            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") ? 56.0f : 44.0f)
#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

#define     SAFEAREA_INSETS     \
({   \
UIEdgeInsets edgeInsets = UIEdgeInsetsZero; \
if (@available(iOS 11.0, *)) {      \
edgeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;     \
}   \
edgeInsets;  \
})\

#pragma mark - 屏幕适配
#define kWidth(R)      (R)*(SCREEN_WIDTH) /375.0f
#define kHeight(R)     (R)*(SCREEN_HEIGHT)/667.0f
#define kFontSize(R)   (IS_IPHONE6P ? (R+2) : (R))
#define kFont(R)       [UIFont systemFontOfSize:kFontSize(R)]
//手机型号的宽高比
#define widthHeight_ratio SCREEN_WIDTH/375

#pragma mark - Chat
#define     MAX_MESSAGE_WIDTH               SCREEN_WIDTH * 0.58
#define     MAX_MESSAGE_IMAGE_WIDTH         SCREEN_WIDTH * 0.45
#define     MIN_MESSAGE_IMAGE_WIDTH         SCREEN_WIDTH * 0.25
#define     MAX_MESSAGE_EXPRESSION_WIDTH    SCREEN_WIDTH * 0.35
#define     MIN_MESSAGE_EXPRESSION_WIDTH    SCREEN_WIDTH * 0.2
#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

#define     HEIGHT_CHATBAR                  (IS_IPHONEX ? 49.0f + 20.0f : 49.0f)

#define     HEIGHT_CHATBAR_TEXTVIEW         36.0f
#define     HEIGHT_MAX_CHATBAR_TEXTVIEW     111.5f
#define     HEIGHT_CHAT_KEYBOARD            215.0f

/********************  常量  ************************/
//默认用户头像高度
static CGFloat const kUserAvatarHeight = 50.0f;

//红色表示的宽度
static CGFloat const kRedPoint_Width = 20.0f;

//女性头像占位图
#define     kDefaultAvatarPath     @"default_user_image"

//男性头像占位图
#define     kDefaultAvatarPathMale @"default_user_image_male"

/********************  Methods  ************************/
#define     YDURL(urlString)        [NSURL URLWithString:urlString]
#define     YDNumberToString(num) [NSString stringWithFormat:@"%@",YDNoNilNumber(num)]
#define     YDImage(imageNameStr)   [UIImage imageNamed:imageNameStr]

#define     YDStandardUserDefaults   [NSUserDefaults standardUserDefaults]
#define     YDNotificationCenter     [NSNotificationCenter defaultCenter]
#define     YDAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

#define     YDNoNilNumber(num)      (num ? num : @0)
#define     YDNoNilString(str)      (str ? str : @"")

#define     YDWeakSelf(type)    __weak typeof(type) weak##type = type;
#define     YDStrongSelf(type)  __strong typeof(type) strong##type = type;
#define     YDTimeStamp(date)   ([NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]]) //时间转成时间戳

#define     YDMessageTimeStamp(date)   ([NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]]) //时间转成时间戳

#define     YDColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]


/** 6位十六进制颜色转换 */
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** 6位十六进制颜色转换，带透明度 */
#define UIAlphaColorFromRGB(rgbValue,a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define     YDSeperatorColor    YDColor(198.9f, 198.9f, 204.f, 1)

#define     YDGlobal_queue  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define     YDMain_queue    dispatch_get_main_queue()


#pragma mark - 第三方配制信息
//极光推送
static NSString *kJPushAppKey = @"7870d78f610e6d2b4596a84e";
static NSString *kJPushChannel = @"App Store";
static BOOL     kJPushIsProduction = YES;

//百度统计key
#define kBaiduMobAppKey @"0945bc67e6"

//百度地图key
#define kBaiduMapKey    @"RlOKnpXvTrSb5ebuOCNObhSKKyEGK5jI"

#endif /* YDMacros_h */

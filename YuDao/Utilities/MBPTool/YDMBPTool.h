//
//  YDMBPTool.h
//  YuDao
//
//  Created by 汪杰 on 16/11/17.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

#pragma mark - 默认显示最长时间
//纯文字
static CGFloat const   kHUDTextTime = 1.5f;

//图片+文字
static CGFloat const   kHUDImageAndTextTime = 3.0f;

//图片+文字 最小尺寸
#define kHUDImageAndTextMiniSize CGSizeMake(187.0f, 112.0f)

//默认Label字体
#define kHUDLabelTextFont  [UIFont fontWithName:@"PingFangSC-Regular" size:16]

//MBP隐藏回调
typedef void(^MBPHideBlock)(void);

//弹出框的类型
typedef NS_ENUM(NSInteger,YDMBPToolShowType) {
    YDMBPToolShowTypeLoading = 0,   //菊花
    YDMBPToolShowTypeText,          //纯文字
    YDMBPToolShowTypeImageAndText,  //图文
};

@interface YDMBPTool : NSObject

/**
 是否可点击背景隐藏加载视图,默认为NO
 */
@property (nonatomic, assign) BOOL tapHide;

/**
 *  隐藏alert
 */
+(void)hideAlert;

#pragma mark - 纯文字
+ (MBProgressHUD *)showText:(NSString *)text;

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view;

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view time:(NSTimeInterval)time;

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view time:(NSTimeInterval)time hideBlock:(MBPHideBlock)hideBlock;

#pragma mark - 带菊花的加载中视图
//+ (MBProgressHUD *)showLoading;

//+ (MBProgressHUD *)showLoadingInView:(UIView *)view;

//+ (MBProgressHUD *)showLoadingInView:(UIView *)view title:(NSString *)title;

//+ (MBProgressHUD *)showLoadingInView:(UIView *)view title:(NSString *)title time:(NSTimeInterval)time;

//+ (MBProgressHUD *)showLoadingInView:(UIView *)view title:(NSString *)title time:(NSTimeInterval)time hideBlock:(MBPHideBlock)hideBlock;

#pragma mark - 纯菊花
+ (MBProgressHUD *)showNoBackgroundViewInView:(UIView *)view;

+ (MBProgressHUD *)showNoBackgroundViewInView:(UIView *)view offset:(CGPoint)offset;

/**
 显示无背景的菊花到view上,view不可为nil

 @param view 要添加到的view
 @param offset 菊花相对view的偏移量，默认是居中
 @param indicatorStyle 菊花样式，默认UIActivityIndicatorViewStyleWhite
 */
+ (MBProgressHUD *)showNoBackgroundViewInView:(UIView *)view offset:(CGPoint)offset indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle;

#pragma mark - 图片+文字
/**
 显示成功图片+文字
 */
+ (MBProgressHUD *)showSuccessImageWithMessage:(NSString *)message
                          hideBlock:(MBPHideBlock)hideBlock;

/**
 显示错误图片+文字
 */
+ (MBProgressHUD *)showErrorImageWithMessage:(NSString *)message
                        hideBlock:(MBPHideBlock)hideBlock;

/**
 显示警告图片+文字
 */
+ (MBProgressHUD *)showInfoImageWithMessage:(NSString *)message
                       hideBlock:(MBPHideBlock)hideBlock;

/**
 *  自定义加载视图接口，支持自定义图片
 *
 *  @param imageName  要显示的图片，最好是37 x 37大小的图片
 *  @param title 要显示的提示文字
 *  @param view 要把提示框添加到的view
 */
+(MBProgressHUD *)showAlertWithCustomImage:(NSString *)imageName
                          title:(NSString *)title
                         inView:(UIView *)view
                      hideBlock:(MBPHideBlock)hideBlock;

@end

//
//  UIImageView+Extensions.h
//  YuDao
//
//  Created by 汪杰 on 2017/3/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (Extensions)

/**
 逐渐显示
 */
- (void)yd_setImageFadeinWithString:(NSString *)urlString;


/**
 带占位图
 */
- (void)yd_setImageWithString:(NSString *)urlString placeholaderImageString:(NSString *)placeholdString;

/**
 *  通过urlString请求图片(无占位图，优先使用硬盘缓存的图片)
 *
 *  @param urlString 网址
 *  @param show      是否开启加载菊花
 *  @param style     菊花样式
 */
- (void)yd_setImageWithString:(NSString *)urlString showIndicator:(BOOL)show indicatorStyle:(UIActivityIndicatorViewStyle)style;

/**
 *  通过urlString请求图片(有占位图，优先使用硬盘缓存的图片)
 *
 *  @param urlString       网址
 *  @param placeholdString 占位图本地字符串
 *  @param show            是否开启加载菊花
 *  @param style           菊花样式
 */
- (void)yd_setImageWithString:(NSString *)urlString placeholaderImageString:(NSString *)placeholdString showIndicator:(BOOL)show indicatorStyle:(UIActivityIndicatorViewStyle)style;

/**
 *  通过urlString请求图片(无展位图，优先使用硬盘缓存的图片)
 *
 *  @param urlString 网址
 *  @param show      是否开启加载菊花
 *  @param style     菊花样式
 *  @param isCircle  是否返回圆形图片
 */
- (void)yd_setImageWithString:(NSString *)urlString showIndicator:(BOOL)show indicatorStyle:(UIActivityIndicatorViewStyle)style isCircle:(BOOL )isCircle;



@end

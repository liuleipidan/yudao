//
//  UIImage+Size.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/19.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)

//根据图片和宽获取新的size
+ (CGSize)yd_getAdaptedSize:(UIImage *)image width:(CGFloat)width;

- (UIImage*)getSubImage:(CGRect)rect;

- (UIImage*)scaleToSize:(CGSize)size;

- (UIImage *)scalingToSize:(CGSize)size;

//将UIImage转换为NSData
+ (NSData*)getDataFromImage:(UIImage*)image;

/**
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param image UIImage image 原始的图片
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
+ (UIImage *)yd_clipImageFromImage:(UIImage *)image inRect:(CGRect)rect;

@end

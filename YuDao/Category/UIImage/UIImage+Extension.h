//
//  UIImage+Extension.h
//  YuDao
//
//  Created by 汪杰 on 16/12/9.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)


/**
 计算图片文件大小（KB）

 @param image 需要计算的图片
 @return 文件大小（KB）
 */
+ (NSUInteger)yd_byteSizeByImage:(UIImage *)image;

/**
 重置图片文件大小
 
 @param sourceImage 图片
 @param maxSize 最大（KM）
 @return UIImage
 */
+ (UIImage *)yd_reSizeImage:(UIImage *)sourceImage maxSizeWithKB:(CGFloat) maxSize;

/**
 重置图片文件大小

 @param sourceImage 图片
 @param maxSize 最大（KM）
 @return NSData
 */
+ (NSData *)yd_reSizeImageData:(UIImage *)sourceImage maxSizeWithKB:(CGFloat) maxSize;

/**
 图片堆叠

 @param image1 底图
 @param image2 覆盖图
 @return 堆叠好的图
 */
+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2;

//颜色转化成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//isCicular是否为圆形
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isCicular:(BOOL)isCicular;

//修正图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//生成圆角图片
-(UIImage*)imageWithCornerRadius:(CGFloat)radius;

//图片模糊处理
- (UIImage *)blurryImage:(UIImage *)image
                withBlur:(CGFloat )blur;

//生成二维码
+ (UIImage *)erCodeImageByUrlString:(NSString *)urlString;

//截图视频缩略图
+ (UIImage *)getThumbnailImage:(NSURL *)url;

//***************   截图   **************
//截取某个View某个范围内的屏幕图像
+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)r;

//截取某个View
+ (UIImage *)getImageFromView:(UIView *)theView;

//截取全屏
+ (UIImage *)fullScreenshots;


@end

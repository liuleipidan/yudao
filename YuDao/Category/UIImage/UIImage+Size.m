//
//  UIImage+Size.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/19.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

+ (CGSize)yd_getAdaptedSize:(UIImage *)image width:(CGFloat)width{
    if (image == nil) {
        return CGSizeZero;
    }
    return CGSizeMake(width, width / image.size.width * image.size.height);
}

- (UIImage *)scalingToSize:(CGSize)size
{
    CGFloat scale = 0.0f;
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (CGSizeEqualToSize(self.size, size) == NO) {
        CGFloat widthFactor = size.width / self.size.width;
        CGFloat heightFactor = size.height / self.size.height;
        scale = (widthFactor > heightFactor ? widthFactor : heightFactor);
        width  = self.size.width * scale;
        height = self.size.height * scale;
        y = (size.height - height) * 0.5;
        
            x = (size.width - width) * 0.5;
        
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(x, y, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) {
        
        return self;
    }
    return newImage ;
}

//将UIImage转换为NSData
+ (NSData*)getDataFromImage:(UIImage*)image{
    
    NSData *data;
    if(UIImagePNGRepresentation(image))
        data = UIImagePNGRepresentation(image);
    else
        data = UIImageJPEGRepresentation(image,0.5);
    return data;

}

//截取部分图像
- (UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext(); 
    CGImageRelease(subImageRef);
    
    return smallImage;
}

+ (UIImage *)yd_clipImageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

//等比例缩放
- (UIImage*)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO,[UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];//根据新的尺寸画出传过来的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    UIGraphicsEndImageContext();//关闭当前环境
    return newImage;
}

@end

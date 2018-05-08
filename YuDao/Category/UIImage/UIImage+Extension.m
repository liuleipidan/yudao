//
//  UIImage+Extension.m
//  YuDao
//
//  Created by 汪杰 on 16/12/9.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "UIImage+Extension.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Extension)

+ (NSUInteger)yd_byteSizeByImage:(UIImage *)image{
    if (image == nil) {
        return 0;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    return [imageData length]/1000;
}

+ (UIImage *)yd_reSizeImage:(UIImage *)sourceImage maxSizeWithKB:(CGFloat) maxSize{
    if (sourceImage == nil) {
        return nil;
    }
    return [UIImage imageWithData:[UIImage yd_reSizeImageData:sourceImage maxSizeWithKB:maxSize]];
}

+ (NSData *)yd_reSizeImageData:(UIImage *)sourceImage maxSizeWithKB:(CGFloat) maxSize
{
    if (sourceImage == nil) {
        return nil;
    }
    if (maxSize <= 0.0) maxSize = 1000.0;
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(sourceImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1000.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(sourceImage,resizeRate);
        sizeOriginKB = imageData.length / 1000.0;
        resizeRate -= 0.1;
    }
    
    return imageData;
}

+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2{
    UIGraphicsBeginImageContext(image1.size);
    
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    [image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2,(image1.size.height - image2.size.height)/2, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    return [UIImage imageWithColor:color size:CGSizeMake(1.0, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    return [UIImage imageWithColor:color size:size isCicular:NO];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isCicular:(BOOL)isCicular{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    if (isCicular) {
        CGContextFillEllipseInRect(context, rect);
    }
    else{
        CGContextFillRect(context, rect);
    }
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


+ (UIImage *)fixOrientation:(UIImage *)aImage{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark 图片模糊处理
- (UIImage *)blurryImage:(UIImage *)image
                withBlur:(CGFloat )blur{
    // 第一种方法
    /*---------------coreImage-------------*/
    // CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    // CIFilter,高斯模糊
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // 将图片输入到滤镜中
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    // 设置模糊程度
    [blurFilter setValue:@(blur) forKey:@"inputRadius"];
    // 用来查询滤镜可以设置的参数以及一些相关的信息
    YDLog(@"%@", [blurFilter attributes]);
    
    // 将处理好的图片输出
    CIImage *outCIImage = [blurFilter valueForKey:kCIOutputImageKey];
    // CIContext
    CIContext *context = [CIContext contextWithOptions:nil];
    // 获取CGImage句柄
    CGImageRef outCGImage = [context createCGImage:outCIImage fromRect:[outCIImage extent]];
    // 最终获取到图片
    UIImage *blurImage = [UIImage imageWithCGImage:outCGImage];
    // 释放CGImage句柄
    CGImageRelease(outCGImage);
    return blurImage;
}


-(UIImage*)imageWithCornerRadius:(CGFloat)radius{
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//生成二维码
+ (UIImage *)erCodeImageByUrlString:(NSString *)urlString{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *cimage = [filter outputImage];
    return [UIImage createNonInterpolatedUIImageFormCIImage:cimage withSize:300];;
}
//二维码图片清晰化
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceRGB颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return outputImage;
}

+ (UIImage *)getThumbnailImage:(NSURL *)url{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}

//***************   截图   **************
//截取某个View某个范围内的屏幕图像
+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)r{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}
//截取某个View
+ (UIImage *)getImageFromView:(UIView *)theView{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *fectchImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fectchImage;
    
}
//截取全屏
+ (UIImage *)fullScreenshots{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    return viewImage;
}

@end

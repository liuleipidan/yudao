//
//  UIImageView+Extensions.m
//  YuDao
//
//  Created by 汪杰 on 2017/3/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "UIImageView+Extensions.h"
#import "SDWebImageManager.h"

@implementation UIImageView (Extensions)

- (void)yd_setImageFadeinWithString:(NSString *)urlString{
    UIImage *placeholder = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if (placeholder) {
        self.image = placeholder;
    }else{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:YDURL(urlString) options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                [self fadeinImage:image];
                [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES completion:^{
                    
                }];
            }
        }];
    }
}

- (void)fadeinImage:(UIImage *)image{
    self.alpha = 0;
    self.image = image;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)yd_setImageWithString:(NSString *)urlString showIndicator:(BOOL)show indicatorStyle:(UIActivityIndicatorViewStyle)style{
    UIImage *placeholder = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if (placeholder) {
        self.image = placeholder;
    }else{
        [self sd_setShowActivityIndicatorView:show];
        [self sd_setIndicatorStyle:style];
        [self sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                self.image = image;
                [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES completion:^{
                    
                }];
            }
        }];
    }
}

- (void)yd_setImageWithString:(NSString *)urlString placeholaderImageString:(NSString *)placeholdString{
    [self yd_setImageWithString:urlString placeholaderImageString:placeholdString showIndicator:NO indicatorStyle:0];
}

- (void)yd_setImageWithString:(NSString *)urlString placeholaderImageString:(NSString *)placeholdString showIndicator:(BOOL)show indicatorStyle:(UIActivityIndicatorViewStyle)style{
    UIImage *placeholder = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if (placeholder) {
        self.image = placeholder;
    }else{
        [self sd_setShowActivityIndicatorView:show];
        [self sd_setIndicatorStyle:style];
        [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:placeholdString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                self.image = image;
                [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES completion:^{
                    
                }];
            }
        }];
    }
}

- (void)yd_setImageWithString:(NSString *)urlString showIndicator:(BOOL)show indicatorStyle:(UIActivityIndicatorViewStyle)style isCircle:(BOOL )isCircle{
    UIImage *placeholder = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if (placeholder) {
        if (isCircle) {
            CGFloat cornerRadius = placeholder.size.width > placeholder.size.height ? placeholder.size.width / 2.0 : placeholder.size.height / 2.0;
            
            self.image = [placeholder imageWithCornerRadius:cornerRadius];
        }else{
            self.image = placeholder;
        }
        
    }else{
        [self sd_setShowActivityIndicatorView:show];
        [self sd_setIndicatorStyle:style];
        [self sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                CGFloat cornerRadius = image.size.width > image.size.height ? image.size.width / 2.0 : image.size.height / 2.0;
                self.image = [image imageWithCornerRadius:cornerRadius];
                [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES completion:^{
                    
                }];
            }
        }];
    }
}

@end

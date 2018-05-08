//
//  UIButton+Extension.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "UIButton+Extension.h"
#import "SDWebImageManager.h"

@implementation UIButton (Extension)

- (void)setImage:(NSString *)imageStr imageHL:(NSString *)HLImageStr{
    [self setImage:imageStr highlightImage:HLImageStr selectedImage:nil disabledImage:nil focusedImage:nil];
}

- (void)setImage:(NSString *)imageStr imageSelected:(NSString *)selectedImageStr{
    [self setImage:imageStr highlightImage:nil selectedImage:selectedImageStr disabledImage:nil focusedImage:nil];
}

- (void)setBackgorudImage:(UIImage *)image imageSelected:(UIImage *)imageSelected{
    
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:imageSelected forState:UIControlStateSelected];
}

//设置button图片总方法
- (void)setImage:(NSString *)imageStr
  highlightImage:(NSString *)hlImageStr
   selectedImage:(NSString *)selectedImageStr
   disabledImage:(NSString *)disableImageStr
    focusedImage:(NSString *)focusedImageStr{
    if (imageStr) {
        [self setImage:YDImage(imageStr) forState:UIControlStateNormal];
    }
    if (hlImageStr) {
        [self setImage:YDImage(hlImageStr) forState:UIControlStateHighlighted];
    }
    if (selectedImageStr) {
        [self setImage:YDImage(selectedImageStr) forState:UIControlStateSelected];
    }
    if (disableImageStr) {
        [self setImage:YDImage(disableImageStr) forState:UIControlStateDisabled];
    }
    if (focusedImageStr) {
        [self setImage:YDImage(focusedImageStr) forState:UIControlStateFocused];
    }
}

- (void)yd_setImage:(NSString *)urlString
   placeholderImage:(NSString *)placeholderImageString{
    UIImage *hadImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if (hadImage) {
        [self setImage:hadImage forState:0];
    }else{
        [self sd_setImageWithURL:YDURL(urlString) forState:0 placeholderImage:[UIImage imageWithContentsOfFile:placeholderImageString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES completion:^{
                
            }];
        }];
        
    }
}

- (void)relayoutSubiews{
    UIImageView *img = self.imageView;
    img.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *lab = self.titleLabel;
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(17);
    }];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.bottom.equalTo(lab).offset(0);
        make.width.mas_equalTo(img.mas_height);
    }];
    [self layoutIfNeeded];
    
}

//******************************  修改图片和文字位置  *************************
- (void)lc_titleImageHorizontalAlignmentWithSpace:(float)space;
{
    [self lc_resetEdgeInsets];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGSize titleSize = [self titleRectForContentRect:contentRect].size;
    CGSize imageSize = [self imageRectForContentRect:contentRect].size;
    
    [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width+space, 0, -titleSize.width - space)];
}

- (void)lc_imageTitleHorizontalAlignmentWithSpace:(float)space;
{
    [self lc_resetEdgeInsets];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
    [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
}

- (void)lc_titleImageVerticalAlignmentWithSpace:(float)space;
{
    [self lc_verticalAlignmentWithTitleTop:YES space:space];
}

- (void)lc_imageTitleVerticalAlignmentWithSpace:(float)space;
{
    [self lc_verticalAlignmentWithTitleTop:NO space:space];
}

- (void)lc_verticalAlignmentWithTitleTop:(BOOL)isTop space:(float)space ;
{
    [self lc_resetEdgeInsets];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGSize titleSize = [self titleRectForContentRect:contentRect].size;
    CGSize imageSize = [self imageRectForContentRect:contentRect].size;
    
    float halfWidth = (titleSize.width + imageSize.width)/2;
    float halfHeight = (titleSize.height + imageSize.height)/2;
    
    float topInset = MIN(halfHeight, titleSize.height);
    float leftInset = (titleSize.width - imageSize.width)>0?(titleSize.width - imageSize.width)/2:0;
    float bottomInset = (titleSize.height - imageSize.height)>0?(titleSize.height - imageSize.height)/2:0;
    float rightInset = MIN(halfWidth, titleSize.width);
    
    if (isTop) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-halfHeight-space, - halfWidth, halfHeight+space, halfWidth)];
        [self setContentEdgeInsets:UIEdgeInsetsMake(topInset+space, leftInset, -bottomInset, -rightInset)];
    } else {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(halfHeight+space, - halfWidth, -halfHeight-space, halfWidth)];
        [self setContentEdgeInsets:UIEdgeInsetsMake(-bottomInset, leftInset, topInset+space, -rightInset)];
    }
}

- (void)lc_resetEdgeInsets
{
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self setImageEdgeInsets:UIEdgeInsetsZero];
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
}

@end

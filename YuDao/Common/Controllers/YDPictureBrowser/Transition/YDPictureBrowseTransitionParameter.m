//
//  YDPictureBrowseTransitionParameter.m
//  YDCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "YDPictureBrowseTransitionParameter.h"

@implementation YDPictureBrowseTransitionParameter

- (void)setTransitionImage:(UIImage *)transitionImage{
    _transitionImage = transitionImage;
    
    _secondVCImgFrame = [self backScreenImageViewRectWithImage:transitionImage];
}
- (void)setTransitionImgIndex:(NSInteger)transitionImgIndex{
    _transitionImgIndex = transitionImgIndex;
    
    _firstVCImgFrame = [_firstVCImgFrames[transitionImgIndex] CGRectValue];
}

//返回imageView在window上全屏显示时的frame
- (CGRect)backScreenImageViewRectWithImage:(UIImage *)image{
    
    CGSize size = image.size;
    CGSize newSize;
    newSize.width = SCREEN_WIDTH;
    newSize.height = newSize.width / size.width * size.height;
    
    CGFloat imageY = (SCREEN_HEIGHT - newSize.height) * 0.5;
    
    if (imageY < 0) {
        imageY = 0;
    }
    CGRect rect =  CGRectMake(0, imageY, newSize.width, newSize.height);
    
    return rect;
}

@end

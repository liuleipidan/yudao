//
//  UIButton+Extension.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)



//********************   设置图片   *********************
- (void)setImage:(NSString *)imageStr imageHL:(NSString *)HLImageStr;

- (void)setImage:(NSString *)imageStr imageSelected:(NSString *)selectedImageStr;

- (void)setBackgorudImage:(UIImage *)image imageSelected:(UIImage *)imageSelected;

- (void)yd_setImage:(NSString *)urlString
   placeholderImage:(NSString *)placeholderImageString;

- (void)relayoutSubiews;

//*******************   修改图片位子位置   ***********************
/**
 水平，文字左，图片右

 @param space 文字与图片间距
 */
- (void)lc_titleImageHorizontalAlignmentWithSpace:(float)space;

/**
 水平，图片左，文字右

 @param space 文字与图片间距
 */
- (void)lc_imageTitleHorizontalAlignmentWithSpace:(float)space;

/**
 垂直，文字上，图片下

 @param space 文字与图片间距
 */
- (void)lc_titleImageVerticalAlignmentWithSpace:(float)space;

/**
 垂直，图片上，文字下

 @param space 文字与图片间距
 */
- (void)lc_imageTitleVerticalAlignmentWithSpace:(float)space;


@end

//
//  YDBlurView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/5.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDBlurView : UIView

- (void)showInView:(UIView *)view
          animated:(BOOL)animated;

/**
 背景图片，默认为空
 */
@property (nonatomic, strong) UIImage *bgImage;

/**
 设置模糊度

 @param radius 模糊值
 */
- (void)setBlurRadius:(CGFloat )radius;

@end

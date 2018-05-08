//
//  YDScrollGradientView.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDScrollGradientView : UIView
/**
 *  是否有下拉动画 在对应的viewcontroller的 scrollViewDidScroll代理里实现wf_parallaxHeaderViewWithOffset方法  默认为YES
 */
@property (nonatomic, assign) BOOL stretchAnimation;

//背景图片网址
@property (nonatomic, copy  ) NSString *bgImageUrl;
//本地背景图片
@property (nonatomic, strong) UIImage *bgImage;

- (void)yd_parallaxViewWithOffsetY:(CGFloat )offsetY;

@end

//
//  YDPopBlurViewManager.h
//  YuDao
//
//  Created by 汪杰 on 17/3/24.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , YDPopBlurType) {
    YDPopBlurTypeDefault,
    YDPopBlurTypeSpring,
};

@interface YDPopBlurViewManager : NSObject

+ (instancetype)showBlurViewWithContentView:(UIView *)contentView
                                initFrame:(CGRect )initFrame
                                blurAlpha:(CGFloat )alpha
                                     type:(YDPopBlurType)type;

+ (void)showWithContentView:(UIView *)contentView
                  blurAlpha:(NSNumber *)alpha
                   withType:(YDPopBlurType )type;

//+ (void)showWithContentView:(UIView *)contentView
//                  fromFrame:(CGRect )frame
//                  blurAlpha:(NSNumber *)alpha
//                   withType:(YDPopBlurType)type;

+ (void)dismiss;

@end

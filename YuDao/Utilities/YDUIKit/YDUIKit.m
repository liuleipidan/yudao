//
//  YDUIKit.m
//  YuDao
//
//  Created by 汪杰 on 16/12/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUIKit.h"

@implementation YDUIKit

+ (UIView *)viewWithBackgroundColor:(UIColor *)backgroundColor{
    return [YDUIKit viewWithBackgroundColor:backgroundColor alpha:1 gestureRecognizer:nil];
}

+ (UIView *)viewWithBackgroundColor:(UIColor *)backgroundColor
                              alpha:(CGFloat )alpha
                  gestureRecognizer:(UIGestureRecognizer *)gesture{
    UIView *view = [UIView new];
    view.backgroundColor = backgroundColor;
    view.alpha = alpha;
    if (gesture) {
        [view addGestureRecognizer:gesture];
    }
    return view;
}

#pragma mark --------------------- UILabel ---------------------------
/** Label 字色  字号 */
+ (UILabel *)labelnumberOfLines:(NSInteger )numberOfLines
                       fontSize:(CGFloat )size
                  textAlignment:(NSTextAlignment )textAlignment{
    return [YDUIKit labelWithBackgroundColor:[UIColor clearColor] textColor:nil textAlignment:textAlignment numberOfLines:numberOfLines text:nil fontSize:size];
}
+ (UILabel *)labelnumberOfLines:(NSInteger )numberOfLines
                       fontSize:(CGFloat )size
                  textAlignment:(NSTextAlignment )textAlignment
                      textColor:(UIColor *)textColor{
    return [YDUIKit labelWithBackgroundColor:[UIColor clearColor] textColor:textColor textAlignment:textAlignment numberOfLines:numberOfLines text:nil fontSize:size];
}
+ (UILabel *)labelTextColor:(UIColor *)textColor
                   fontSize:(CGFloat )size{
    return [YDUIKit labelWithBackgroundColor:[UIColor clearColor] textColor:textColor textAlignment:NSTextAlignmentLeft numberOfLines:1 text:nil fontSize:size];
}

+ (UILabel *)labelTextColor:(UIColor *)textColor
                   fontSize:(CGFloat )size
              textAlignment:(NSTextAlignment )textAlignment{
    return [YDUIKit labelWithBackgroundColor:[UIColor clearColor] textColor:textColor textAlignment:textAlignment numberOfLines:1 text:nil fontSize:size];
}

/** Label 文字  字号 */
+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat )size{
    return [YDUIKit labelWithBackgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft numberOfLines:1 text:text fontSize:size];
}

+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                  numberOfLines:(NSInteger )numberOfLines
                           text:(NSString *)text
                       fontSize:(CGFloat )size{
    return [YDUIKit labelWithBackgroundColor:[UIColor clearColor] textColor:textColor textAlignment:NSTextAlignmentLeft numberOfLines:numberOfLines text:text fontSize:size];
}

/** Label 字色  文字  字号  对齐方式*/
+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                           text:(NSString *)text
                       fontSize:(CGFloat )size
                  textAlignment:(NSTextAlignment )textAlignment{
    return [YDUIKit labelWithBackgroundColor:[UIColor clearColor] textColor:textColor textAlignment:textAlignment numberOfLines:1 text:text fontSize:size];
}

+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                        textAlignment:(NSTextAlignment)textAlignment
                        numberOfLines:(NSInteger)numberOfLines
                                 text:(NSString *)text
                             fontSize:(CGFloat)size{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = backgroundColor;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    //label.font = [UIFont fontWithName:@"" size:size];
    return label;
}

#pragma mark --------------------- UIImageView ---------------------------
+ (UIImageView *)imageViewWithimage:(UIImage *)image{
    return nil;
}


#pragma mark --------------------- UIButton ---------------------------
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                        image:(UIImage *)image
                selectedImage:(UIImage *)selectedImage
              backgroundImage:(UIImage *)backImage
                       target:(id)target{
    return [YDUIKit buttonWithTitle:title titleColor:titleColor backgroundColor:backgroundColor image:image selectedImage:selectedImage backgroundImage:backImage selector:nil target:target];
}
+ (UIButton *)buttonWithTitle:(NSString *)title
                        image:(UIImage *)image
                selectedImage:(UIImage *)selectedImage
                       target:(id)target{
    return [YDUIKit buttonWithTitle:title titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] image:image selectedImage:selectedImage backgroundImage:nil selector:nil target:target];
}
+ (UIButton *)buttonWithTitle:(NSString *)title
                        image:(UIImage *)image
                       target:(id)target{
    return [YDUIKit buttonWithTitle:title titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] image:image selectedImage:image backgroundImage:nil selector:nil target:target];
}
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                       target:(id)target{
    return [YDUIKit buttonWithTitle:title titleColor:titleColor backgroundColor:[UIColor clearColor] image:nil selectedImage:nil backgroundImage:nil selector:nil target:target];
}
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                     selector:(SEL )selector
                       target:(id)target{
    return [YDUIKit buttonWithTitle:title titleColor:titleColor backgroundColor:backgroundColor image:nil selectedImage:nil backgroundImage:nil selector:selector target:target];
}

+ (UIButton *)buttonWithImage:(UIImage *)image
                       target:(id)target{
    return [YDUIKit buttonWithTitle:nil titleColor:nil backgroundColor:[UIColor clearColor] image:image selectedImage:image backgroundImage:nil selector:nil target:target];
}

+ (UIButton *)buttonWithImage:(UIImage *)image
                selectedImage:(UIImage *)selectedImage
                     selector:(SEL )selector
                       target:(id)target{
    return [YDUIKit buttonWithTitle:nil titleColor:nil backgroundColor:[UIColor clearColor] image:image selectedImage:selectedImage backgroundImage:nil selector:selector target:target];
}

+ (UIButton *)buttonWithBackgroudImage:(UIImage *)image
                                target:(id)target{
    return [YDUIKit buttonWithTitle:nil titleColor:nil backgroundColor:[UIColor clearColor] image:nil selectedImage:nil backgroundImage:image selector:nil target:target];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                        image:(UIImage *)image
                selectedImage:(UIImage *)selectedImage
              backgroundImage:(UIImage *)backImage
                     selector:(SEL )selector
                       target:(id)target{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:0];
    [btn setTitleColor:titleColor forState:0];
    [btn setBackgroundColor:backgroundColor];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    [btn setBackgroundImage:backImage forState:0];
    if (selector) {
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

@end

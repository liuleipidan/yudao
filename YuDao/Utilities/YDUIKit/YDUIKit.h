//
//  YDUIKit.h
//  YuDao
//
//  Created by 汪杰 on 16/12/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDUIKit : NSObject

#pragma mark --------------------- UIView ---------------------------
+ (UIView *)viewWithBackgroundColor:(UIColor *)backgroundColor;

#pragma mark --------------------- UILabel ---------------------------
/** Label 字色  字号 */
+ (UILabel *)labelnumberOfLines:(NSInteger )numberOfLines
                      fontSize:(CGFloat )size
                  textAlignment:(NSTextAlignment )textAlignment;

/** Label 字色  字号 */
+ (UILabel *)labelnumberOfLines:(NSInteger )numberOfLines
                       fontSize:(CGFloat )size
                  textAlignment:(NSTextAlignment )textAlignment
                      textColor:(UIColor *)textColor;
/** Label 字色  字号 */
+ (UILabel *)labelTextColor:(UIColor *)textColor
                  fontSize:(CGFloat )size;

/** Label 字色  字号 对齐方式 */
+ (UILabel *)labelTextColor:(UIColor *)textColor
                   fontSize:(CGFloat )size
              textAlignment:(NSTextAlignment )textAlignment;

/** Label 文字  字号 */
+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat )size;

/** Label 字色  行数  文字  字号 */
+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                  numberOfLines:(NSInteger )numberOfLines
                           text:(NSString *)text
                       fontSize:(CGFloat )size;
/** Label 字色  文字  字号  对齐方式*/
+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                           text:(NSString *)text
                       fontSize:(CGFloat )size
                  textAlignment:(NSTextAlignment )textAlignment;

+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                        textAlignment:(NSTextAlignment )textAlignment
                        numberOfLines:(NSInteger )numberOfLines
                                 text:(NSString *)text
                             fontSize:(CGFloat )size;

#pragma mark --------------------- UIImageView ---------------------------

/** UIImageView 图片 */
+ (UIImageView *)imageViewWithimage:(UIImage *)image;


#pragma mark --------------------- UIButton ---------------------------
+ (UIButton *)buttonWithTitle:(NSString *)title
                        image:(UIImage *)image
                selectedImage:(UIImage *)selectedImage
                       target:(id)target;
+ (UIButton *)buttonWithTitle:(NSString *)title
                        image:(UIImage *)image
                       target:(id)target;;
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                       target:(id)target;;
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                     selector:(SEL )selector
                       target:(id)target;

+ (UIButton *)buttonWithImage:(UIImage *)image
                       target:(id)target;

+ (UIButton *)buttonWithBackgroudImage:(UIImage *)image
                                target:(id)target;

+ (UIButton *)buttonWithImage:(UIImage *)image
               selectedImage:(UIImage *)selectedImage
                    selector:(SEL )selector
                       target:(id)target;

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                        image:(UIImage *)image
                selectedImage:(UIImage *)selectedImage
              backgroundImage:(UIImage *)backImage
                       target:(id)target;


@end

//
//  UILabel+Extentsion.m
//  YuDao
//
//  Created by 汪杰 on 17/1/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "UILabel+Extentsion.h"

@implementation UILabel (Extentsion)

+ (UILabel *)labelByTextColor:(UIColor *)textColor font:(UIFont *)font{
    return [UILabel labelByTextColor:textColor font:font textAlignment:0 backgroundColor:[UIColor clearColor]];
}

+ (UILabel *)labelByTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment{
    return [UILabel labelByTextColor:textColor font:font textAlignment:alignment backgroundColor:[UIColor clearColor]];
}

+ (UILabel *)labelByTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment backgroundColor:(UIColor *)backgroundColor{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = alignment;
    label.backgroundColor = backgroundColor ? : [UIColor clearColor];
    return label;
}

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

- (void)yd_setText:(NSString *)text lineSpace:(CGFloat)lineSpace{
    if (lineSpace < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange range1 = NSMakeRange(0, text.length-2);
    NSRange range2 = NSMakeRange(range1.length, 2);
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range1];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range2];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

- (void)yd_setText:(NSString *)text color1:(UIColor *)color1 color2:(UIColor *)color2{
    if (text.length == 0) {
        self.text = @"";
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange range1 = NSMakeRange(0, 2);
    NSRange range2 = NSMakeRange(2, text.length-2);
    
    //设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏，解决UILabel文本竖直居中
    [attributedString addAttributes:@{
                                      NSBaselineOffsetAttributeName: @(2),
                                      NSFontAttributeName:[UIFont systemFontOfSize:12],
                                      NSForegroundColorAttributeName:color1
                                      } range:range1];
//    NSString *subString = [text substringWithRange:range2];
//
    [attributedString addAttributes:@{
                                      NSFontAttributeName:[UIFont systemFontOfSize:20],
                                      NSForegroundColorAttributeName:color2
                                      } range:range2];
    
    self.attributedText = attributedString;
}

- (void)setLabelAttributeWithContent:(NSString *)content footString:(NSString *)footString{
    NSString *originStr = [content stringByAppendingString:footString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:originStr];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(originStr.length-2, 2)];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(originStr.length-4, 2)];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, originStr.length-4)];
    self.attributedText = attributeString;
}

@end

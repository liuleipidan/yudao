//
//  UIColor+YuDao.m
//  YuDao
//
//  Created by 汪杰 on 16/10/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "UIColor+YuDao.h"

#define     YDColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]


@implementation UIColor (YuDao)

+ (UIColor *)colorWithString:(NSString *)colorString{
    
    NSMutableString *color = [NSMutableString stringWithString:colorString];
    
    if ([colorString containsString:@"#"]) {
        // 转换成标准16进制数
        [color replaceCharactersInRange:[color rangeOfString:@"#"] withString:@"0x"];
    }
    
    // 十六进制字符串转成整形。
    long colorLong = strtoul([color cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    // 通过位与方法获取三色值
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    
    //string转color
    UIColor *wordColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    return wordColor;
}

+ (UIColor *)baseColor{
    return YDColor(43, 53, 82, 1);
}

+ (UIColor *)blackTextColor{
    return YDColor(42, 42, 42, 1);
}

+ (UIColor *)grayTextColor{
    return YDColor(153, 153, 153, 1);
}

+ (UIColor *)grayTextColor1{
    return YDColor(223, 223, 223, 1);
}

+ (UIColor *)orangeTextColor{
    return YDColor(255, 153, 116, 1);
}

+ (UIColor *)greenTextColor{
    return YDColor(171, 218, 120, 1);
}

+ (UIColor *)grayCellLineColor{
    return YDColor(223, 223, 223, 1);
}

+ (UIColor *)tableViewSectionHeaderViewBackgoundColor{
    return YDColor(240, 240, 240, 1);
}

+ (UIColor *)shadowColor{
    return YDColor(223, 223, 223, 1);
}

+ (UIColor *)lineColor{
    return YDColor(245, 245, 245, 1);
}

+ (UIColor *)grayBackgoundColor{
    return YDColor(245, 245, 245, 1);
}

+ (UIColor *)searchBarBackgroundColor{
    return YDColor(240, 240, 240, 1);
}

+ (UIColor *)lineColor1{
    return YDColor(223, 223, 223, 1);
}

#pragma mark - # 字体
+ (UIColor *)colorTextBlack {
    return [UIColor blackColor];
}

+ (UIColor *)colorTextGray {
    return [UIColor grayColor];
}

+ (UIColor *)colorTextGray1 {
    return YDColor(160, 160, 160, 1.0);
}

#pragma mark - 灰色
+ (UIColor *)colorGrayBG {
    return YDColor(239.0, 239.0, 244.0, 1.0);
}

+ (UIColor *)colorGrayCharcoalBG {
    return YDColor(235.0, 235.0, 235.0, 1.0);
}

+ (UIColor *)colorGrayLine {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

+ (UIColor *)colorGrayForChatBar {
    return YDColor(245.0, 245.0, 247.0, 1.0);
}

+ (UIColor *)colorGrayForMoment {
    return YDColor(243.0, 243.0, 245.0, 1.0);
}




#pragma mark - 绿色
+ (UIColor *)colorGreenDefault {
    return YDColor(2.0, 187.0, 0.0, 1.0f);
}


#pragma mark - 蓝色
+ (UIColor *)colorBlueMoment {
    return YDColor(74.0, 99.0, 141.0, 1.0);
}

#pragma mark - 黑色
+ (UIColor *)colorBlackForNavBar {
    return YDColor(20.0, 20.0, 20.0, 1.0);
}

+ (UIColor *)colorBlackBG {
    return YDColor(46.0, 49.0, 50.0, 1.0);
}

+ (UIColor *)colorBlackAlphaScannerBG {
    return [UIColor colorWithWhite:0 alpha:0.3];
}

+ (UIColor *)colorBlackForAddMenu {
    return YDColor(71, 70, 73, 1.0);
}

+ (UIColor *)colorBlackForAddMenuHL {
    return YDColor(65, 64, 67, 1.0);
}


@end

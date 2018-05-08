//
//  NSString+Extension.m
//  YuDao
//
//  Created by 汪杰 on 17/2/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/*
 round  如果参数是小数  则求本身的四舍五入.         （正常的四舍五入）
 ceil   如果参数是小数  则求最小的整数但不小于本身.   （向上去整）
 floor  如果参数是小数  则求最大的整数但不大于本身.   （向下去整）
 */

- (CGFloat)yd_stringHeightBySize:(CGSize)size font:(UIFont *)font{
    if (self.length == 0) {
        return 0;
    }
    return ceil([self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height);
}

- (CGFloat)yd_stringWidthBySize:(CGSize)size font:(UIFont *)font{
    if (self.length == 0) {
        return 0;
    }
    return ceil([self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width);
}

- (CGFloat)yd_stringHeightBySize:(CGSize)size attributes:(NSDictionary *)attributes{
    if (self.length == 0) {
        return 0;
    }
    return ceil([self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height);
}


- (NSString *)yd_URLEncode{
    if (self.length == 0) {
        return @"";
    }
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

- (BOOL)isMobileNumber
{
    if (self.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|73|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



- (NSString *)weatherImagePathByWeatherCode:(NSString *)code{
    
    NSArray *oneArray   = @[@"00"];
    NSArray *twoArray   = @[@"01",@"02"];
    NSArray *threeArray = @[@"03",@"04",@"05",@"06",@"07",@"08",@"21",@"22"];
    NSArray *fourArray  = @[@"09",@"10",@"11",@"12",@"19",@"23",@"24",@"25"];
    NSArray *fiveArray  = @[@"13",@"14",@"15",@"16",@"17",@"26",@"27",@"28"];
    NSString *string = nil;
    if ([oneArray containsObject:code]) {//晴
        string = @"weather_q";
    }
    else if ([twoArray containsObject:code]){//阴
        string = @"weather_dy";
    }
    else if ([threeArray containsObject:code]){//雨
        string = @"weather_lzy";
    }
    else if ([fourArray containsObject:code]){//大雨
        string = @"weather_yy";
    }
    else if ([fiveArray containsObject:code]){//雪
        string = @"weather_x";
    }
    else{//其他天气
        string = @"weather_dy";
    }
    return string;
}

/**
 * 字符串长度
 */
- (NSUInteger)textLength{
    if (!self || self.length == 0) {
        return 0;
    }
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength;
    return unicodeLength;
}

+ (NSString *)removeSpecialCharacter:(NSString *)str{
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self removeSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

@end

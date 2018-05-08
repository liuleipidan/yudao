//
//  YDUser.m
//  YuDao
//
//  Created by 汪杰 on 16/10/20.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUser.h"
#import "NSString+PinYin.h"


@implementation YDUser

+ (NSArray *)mj_ignoredPropertyNames{
    return @[
             @"oftenPlace",
             @"oftenPlace_1",
             @"emotionString",
             @"authString"
             ];
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if (property.type.typeClass == [NSString class]) {
        if (!oldValue || oldValue == NULL || oldValue == nil) {
            
            return @"";
        }
    }
    if (property.type.typeClass == [NSNumber class]) {
        if ([oldValue  isEqual: @""] || !oldValue  || oldValue == NULL || oldValue == nil) {
            return @0;
        }
        NSNumber * num = oldValue;
        if (num.integerValue < 0) {
            return @0;
        }
    }
    
    return oldValue;
}

- (YDUser *)getTempUserData{
    NSDictionary *userDic = [YDUserDefault defaultUser].user.mj_keyValues;
    return[YDUser mj_objectWithKeyValues:userDic];
}

- (BOOL)compareUserCanChangeInformation:(YDUser *)user{
    //昵称
    if (![self.ub_nickname isEqualToString:user.ub_nickname]) {
        return NO;
    }
    
    //真实姓名
    if (![self.ud_realname isEqualToString:user.ud_realname]) {
        return NO;
    }
    
    //年龄
    if (![self.ud_age isEqual:user.ud_age] ||
        ![self.ud_birth isEqual:user.ud_birth] ||
        ![self.ud_constellation isEqualToString:user.ud_constellation]) {
        return NO;
    }
    
    //性别
    if (![self.ud_sex isEqual:user.ud_sex]) {
        return NO;
    }
    
    //情感状态
    if (![self.ud_emotion isEqual:user.ud_emotion]) {
        return NO;
    }
    
    //常出没地点
    if (![self.ud_often_province isEqual:user.ud_often_province] ||
        ![self.ud_often_city isEqual:user.ud_often_city] ||
        ![self.ud_often_area isEqual:user.ud_often_area]) {
        return NO;
    }
    
    return YES;
}

- (NSString *)oftenPlace{
    if (self.ud_often_province_name.length == 0) {
        return @"未知";
    }
    NSArray *citys = @[@"上海市",@"北京市",@"天津市",@"重庆市"];
    NSString *place = @"";
    if ([citys containsObject:self.ud_often_province_name]) {
        place = [self.ud_often_province_name stringByAppendingString:self.ud_often_area_name];
    }else{
        place = [self.ud_often_city_name stringByAppendingString:self.ud_often_area_name];
    }
    return place;
}

- (NSString *)oftenPlace_1{
    if (self.ud_often_province_name.length == 0) {
        return @"未知";
    }
    NSArray *citys = @[@"上海市",@"北京市",@"天津市",@"重庆市"];
    NSString *place = @"";
    if ([citys containsObject:self.ud_often_province_name]) {
        place = self.ud_often_province_name;
    }else{
        place = self.ud_often_city_name;
    }
    return place;
}

- (NSString *)emotionString{
    static NSDictionary *emotionStringDic = nil;
    if (emotionStringDic == nil) {
        emotionStringDic = @{
                             @0:@"保密",
                             @1:@"单身",
                             @2:@"已婚",
                             @3:@"离异",
                             @4:@"恋爱"
                             };
    }
    return emotionStringDic[YDNoNilNumber(self.ud_emotion)] ? : @"保密";
}

- (NSString *)authString{
    static NSDictionary *authStringDic = nil;
    if (authStringDic == nil) {
        authStringDic = @{
                          @0:@"我要认证",
                          @1:@"已认证",
                          @2:@"认证中",
                          @3:@"认证失败"
                          };
    }
    return authStringDic[YDNoNilNumber(self.ud_userauth)] ? : @"我要认证";
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",self.access_token,self.ub_name,self.ub_nickname,self.ub_cellphone,self.ub_password,self.ud_face,self.ud_constellation,self.ud_realname,self.ud_often_province_name,self.ud_often_area_name,self.ud_tag,self.ud_tag_name,self.ub_id,self.ud_age,self.ud_sex,self.ud_emotion,self.ud_userauth,YDNoNilNumber(self.ud_often_city),YDNoNilNumber(self.ud_often_province),self.ud_often_area_name,self.ud_age_display,self.ud_constellation];
}

@end

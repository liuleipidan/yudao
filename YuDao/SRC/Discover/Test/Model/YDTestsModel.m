//
//  YDTestsModel.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestsModel.h"

@implementation YDTestsModel

//替代属性名
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"illegalArray":@"wz",
             @"veAirMallLinkUrl":@"goodsDetUrl"
             };
}
//指定数组对象类名
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"illegalArray":@"YDIllegalModel"
             };
}

- (NSString *)faultString{
    if (_faultString == nil) {
        if (self.faultcode == nil || [self.faultcode isEqual:@0]) {
            _faultString = @"正常";
        }
        else{
            _faultString = [NSString stringWithFormat:@"%@",self.faultcode];
        }
    }
    return _faultString;
}

@end

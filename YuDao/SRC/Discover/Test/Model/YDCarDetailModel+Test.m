//
//  YDCarDetailModel+Test.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDCarDetailModel+Test.h"

static const void *kCarDetails_test = @"kCarDetails_test";

@implementation YDCarDetailModel (Test)

- (void)setTestModel:(YDTestsModel *)testModel{
    objc_setAssociatedObject(self, &kCarDetails_test, testModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YDTestsModel *)testModel{
    return objc_getAssociatedObject(self, &kCarDetails_test);
}

- (BOOL)isBound_BOX{
    return [self.ug_boundtype isEqual:@1];
}

- (BOOL)isBound_AIR{
    return [self.ug_bind_air isEqual:@1];
}

- (NSDictionary *)cellHeightDic{
    if ((self.isBound_BOX && self.isBound_AIR) ||
        (self.isBound_BOX && !self.isBound_AIR)) {
        return @{
                 @"0":@130,
                 @"1":@130,
                 @"2":@151,
                 @"3":@151,
                 @"4":@130,
                 @"5":@188
                 };
    }
    else if (!self.isBound_BOX && self.isBound_AIR){
        return @{
                 @"0":@151,
                 @"1":@151
                 };
    }
    else{
        return @{};
    }
}

@end

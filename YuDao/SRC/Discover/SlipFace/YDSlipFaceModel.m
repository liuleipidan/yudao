//
//  YDSlipFaceModel.m
//  YuDao
//
//  Created by 汪杰 on 17/1/17.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSlipFaceModel.h"

@implementation YDSlipFaceModel

- (NSMutableArray *)interestArray{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:5];
    [tempArray addObjectsFromArray:[self.ud_tag_name componentsSeparatedByString:@","]];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string = obj;
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            [tempArray removeObject:obj];
        }
    }];
    return tempArray;
}

@end

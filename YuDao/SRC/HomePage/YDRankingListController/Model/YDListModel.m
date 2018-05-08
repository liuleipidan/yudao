//
//  YDRingListModel.m
//  YuDao
//
//  Created by 汪杰 on 16/11/29.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDListModel.h"

@implementation YDListModel

- (NSString *)sex{
    if ([self.ud_sex isEqual:@1]) {
        return @"男";
    }else{
        return @"女";
    }
}

+ (NSString *)rankingImageByRank:(NSInteger )rank{
    static NSDictionary *rankingImageDic;
    if (rankingImageDic == nil) {
        rankingImageDic = @{
                            @1: @"rankinglist_1st",
                            @2: @"rankinglist_2sd",
                            @3: @"rankinglist_3th",
                            @4: @"rankinglist_4~10",
                            };
    }
    return rankingImageDic[@(rank)] ? : @"rankinglist_4~10";
}

@end

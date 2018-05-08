//
//  YDVisitorsModel.m
//  YuDao
//
//  Created by 汪杰 on 17/1/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDVisitorsModel.h"

@implementation YDVisitorsModel

- (NSString *)timeInfo{
    if (_timeInfo == nil) {
        _timeInfo = [NSDate timeInfoWithDate:self.lasttimeInt];
    }
    return _timeInfo;
}

@end

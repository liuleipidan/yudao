//
//  YDAdvise.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDAdvise.h"

@implementation YDAdvise

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"content":@"fb_opinion",
             @"time":@"fb_time",
             @"type":@"fb_type",
             @"answers":@"replies"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"answers":@"YDAdviseAnswer"
             };
}

#pragma mark - Getters
- (CGFloat)contentHeight{
    if (_contentHeight == 0) {
        if (self.content.length == 0) {
            _contentHeight = 0;
        }
        else{
            _contentHeight = [self.content yd_stringHeightBySize:CGSizeMake(SCREEN_WIDTH-88, CGFLOAT_MAX) font:[UIFont font_16]];
        }
    }
    return _contentHeight;
}

- (CGFloat)topPartHeight{
    if (_topPartHeight == 0) {
        _topPartHeight = 15 + 40 + 7 + self.contentHeight + 15;
    }
    return _topPartHeight;
}

- (CGFloat)wholeHeight{
    if (_wholeHeight == 0) {
        _wholeHeight = self.topPartHeight;
        if (self.answers.count > 0) {
            [self.answers enumerateObjectsUsingBlock:^(YDAdviseAnswer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                _wholeHeight += obj.allHeight;
            }];
        }
    }
    return _wholeHeight;
}

@end


@implementation YDAdviseAnswer

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ub_id":@"users_id",
             @"name":@"yd_name",
             @"content":@"reply",
             @"time":@"created_at"
             };
}

- (CGFloat)contentHeight{
    if (_contentHeight == 0) {
        if (self.content.length == 0) {
            _contentHeight = 0;
        }
        else{
            _contentHeight = [self.content yd_stringHeightBySize:CGSizeMake(SCREEN_WIDTH-88, CGFLOAT_MAX) font:[UIFont font_16]];
        }
    }
    return _contentHeight;
}

- (CGFloat)allHeight{
    if (_allHeight == 0) {
        _allHeight = 10 + 22 + 1 + 17 + 7 + self.contentHeight + 10;
    }
    return _allHeight;
}

@end

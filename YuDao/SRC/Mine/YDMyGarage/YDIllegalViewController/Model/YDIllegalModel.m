//
//  YDIllegalModel.m
//  YuDao
//
//  Created by 汪杰 on 17/3/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDIllegalModel.h"

@implementation YDIllegalModel

- (NSString *)showTime{
    if (self.time == nil) {
        return @"未知";
    }
    return [NSDate formatYear_Month_Day:self.time];
}

- (NSString *)day{
    NSDate *date = [NSDate dateFromTimeStamp:self.time];
    return [NSString stringWithFormat:@"%ld",date.day];
}

- (NSString *)month{
    NSDate *date = [NSDate dateFromTimeStamp:self.time];
    return [NSString stringWithFormat:@"%ld月",date.month];
}

- (CGFloat)addressHeight{
    if (_addressHeight == 0) {
        if (self.address.length == 0) {
            _addressHeight = 20.0f;
        }
        else{
            _addressHeight = [self.address yd_stringHeightBySize:CGSizeMake(SCREEN_WIDTH-114-20, CGFLOAT_MAX) font:[UIFont font_14]];
        }
    }
    return _addressHeight > 20.0f ? _addressHeight : 20.0f;
}

- (CGFloat)contentHeight{
    if (_contentHeight == 0) {
        if (_content.length == 0) {
            _contentHeight = 20.0f;
        }
        else{
            _contentHeight = [self.content yd_stringHeightBySize:CGSizeMake(SCREEN_WIDTH-114-20, CGFLOAT_MAX) font:[UIFont font_14]];
        }
    }
    return _contentHeight > 20.0f ? _contentHeight : 20.0f;
}

- (CGFloat)cellHeight{
    if (_cellHeight == 0) {
        _cellHeight = 10 + 10 + self.addressHeight + 8 + self.contentHeight + 7 + 35 + 10;
    }
    return _cellHeight;
}

@end

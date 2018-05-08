//
//  YDLabelViewModel.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/3.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDLabelViewModel.h"
#import "YDUserDefaultsManager.h"

@implementation YDLabelViewModel

- (id)init{
    if (self = [super init]) {
        _hotArr = [NSMutableArray array];
        
        _historyArr = [NSMutableArray arrayWithArray:[[YDUserDefaultsManager manager] dynamicLabelHistory]];
    }
    return self;
}

- (void)setHotArr:(NSMutableArray *)hotArr{
    _hotArr = hotArr;
    _hotButtonPropertys = nil;
}

- (void)insertUserDynamicLabel:(NSString *)label{
    if (label.length == 0) {
        return;
    }
    [[YDUserDefaultsManager manager] insertUserDynamicLabel:label];
}

- (void)removeUserDynamicLabel:(NSString *)label{
    if (label.length == 0) {
        return;
    }
    [[YDUserDefaultsManager manager] removeHistoryLabelsByLabel:label];
}

- (NSMutableArray *)hotButtonPropertys{
    if (_hotButtonPropertys == nil) {
        
        CGFloat marginX = 20.f;
        CGFloat marginY = 12.f;
        NSInteger row = 0;
        CGFloat maxX = 0;
        CGFloat height = 26.f;
        _hotButtonPropertys = [NSMutableArray arrayWithCapacity:_hotArr.count];
        if (_hotArr.count == 0) {
            _hotCellHeight = marginY * 2 + height;
        }
        else{
            for (int i = 0; i < _hotArr.count; i++) {
                NSString *title = _hotArr[i];
                CGFloat width = [title yd_stringWidthBySize:CGSizeMake(CGFLOAT_MAX, 26) font:[UIFont font_14]] + 30.f;
                
                CGFloat x = 0,y = 0;
                if (i == 0) {
                    x = marginX;
                    maxX = x + width;
                }
                else{
                    maxX += (marginX + width);
                    if (maxX > SCREEN_WIDTH - 20) {
                        row++;
                        x = marginX;
                        maxX = x + width;
                    }
                    else{
                        x += maxX - width;
                    }
                }
                y = row * (height + marginY) + marginY;
                
                [_hotButtonPropertys addObject:@{
                                                 @"title":title,
                                                 @"frame":[NSValue valueWithCGRect:CGRectMake(x, y, width, height)]
                                                 }];
                if (i == _hotArr.count - 1) {
                    _hotCellHeight = y + height + marginY;
                }
            }
        }
    }
    
    return _hotButtonPropertys;
}

@end

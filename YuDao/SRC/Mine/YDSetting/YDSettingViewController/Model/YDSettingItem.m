//
//  YDSettingItem.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingItem.h"

@implementation YDSettingItem

+ (YDSettingItem *)createItemWithTitle:(NSString *)title{
    YDSettingItem *item = [[YDSettingItem alloc] init];
    item.title = title;
    return item;
}

- (id)init{
    if (self = [super init]) {
        self.showDisclosureIndicator = YES;
        self.disableHighlight = NO;
        self.switchStatus = YES;
    }
    return self;
}

- (BOOL)switchStatus{
    if (self.ignoreModel && ![self.ignoreModel.ignore_type isEqual:@0]) {
        return NO;
    }
    return YES;
}

- (NSString *)cellClassName{
    switch (self.type) {
        case YDSettingItemTypeDefault:
            return @"YDSettingCell";
            break;
        case YDSettingItemTypeTitleButton:
            return @"YDSettingButtonCell";
            break;
        case YDSettingItemTypeSwitch:
            return @"YDSettingSwitchCell";
            break;
        default:
            break;
    }
    return nil;
}

@end

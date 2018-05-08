//
//  YDMyInfoItem.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/18.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMyInfoItem.h"

@implementation YDMyInfoItem

- (NSString *)cellClassName{
    static NSDictionary *myInfoItemCellClassDic;
    if (myInfoItemCellClassDic == nil) {
        myInfoItemCellClassDic = @{
                                   @(YDMyInfoItemTypeDefault):@"YDMyInfoCell",
                                   @(YDMyInfoItemTypeAvatar):@"YDMyInfoAvatarCell",
                                   @(YDMyInfoItemTypeInput):@"YDMyInfoInputCell",
                                   @(YDMyInfoItemTypeOther):@"YDMyInfoCell",
                                   };
    }
    return myInfoItemCellClassDic[@(self.type)] ? : @"YDMyInfoCell";
}

+ (YDMyInfoItem *)createItemWithTitle:(NSString *)title{
    YDMyInfoItem *item = [[YDMyInfoItem alloc] init];
    item.title = title;
    return item;
}

- (id)init{
    if (self = [super init]) {
        self.type = YDMyInfoItemTypeDefault;
        self.showDisclosureIndicator = YES;
        self.disableHighlight = NO;
        self.disableSubTitle = NO;
    }
    return self;
}

@end

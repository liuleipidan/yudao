//
//  YDSettingGroup.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSettingGroup.h"

@implementation YDSettingGroup

+ (YDSettingGroup *)createGroupWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle items:(NSMutableArray *)items{
    YDSettingGroup *group = [[YDSettingGroup alloc] init];
    group.headerTitle = headerTitle;
    group.footerTitle = footerTitle;
    group.items = items;
    
    return group;
}

#pragma mark - Public Methods
- (id)objectAtIndex:(NSUInteger )index{
    return [self.items objectAtIndex:index];
}

- (NSUInteger)indexOfObject:(id)obj{
    return [self.items indexOfObject:obj];
}

- (void)removeObject:(id)obj{
    [self.items removeObject:obj];
}

#pragma mark - Setter
- (void)setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    if (headerTitle == nil || headerTitle.length == 0) {
        _headerHeight = 0.f;
    }
    else{
        _headerHeight = [headerTitle yd_stringHeightBySize:CGSizeMake(SCREEN_WIDTH-30,CGFLOAT_MAX) font:[UIFont font_14]];
    }
}

- (void)setFooterTitle:(NSString *)footerTitle{
    _footerTitle = footerTitle;
    if (footerTitle == nil || footerTitle.length == 0) {
        _footerHeight = 0.f;
    }
    else{
        _footerHeight = [_footerTitle yd_stringHeightBySize:CGSizeMake(SCREEN_WIDTH-30,CGFLOAT_MAX) font:[UIFont font_14]];
    }
}

#pragma mark - Getter
- (NSUInteger)count{
    return self.items.count;
}

@end

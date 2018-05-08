//
//  UIView+Extensions.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

- (void)removeAllSubViews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)yd_addSubviews:(NSArray *)subviews{
    if (!subviews) {
        return;
    }
    [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
}

@end

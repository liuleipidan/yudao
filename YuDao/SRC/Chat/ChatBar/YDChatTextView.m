//
//  YDChatTextView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/23.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDChatTextView.h"

@interface YDChatTextView()


@end

@implementation YDChatTextView

- (UIResponder *)nextResponder{
    if (_overrideNext != nil)
        return _overrideNext;
    else
        return [super nextResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_overrideNext != nil)
        return NO;
    else
        return [super canPerformAction:action withSender:sender];
}

@end

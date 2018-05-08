//
//  YDCoustomTapGestureRecognizer.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCoustomTapGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

//单击后最长延迟时间，也就是说0.25内要点击两下才能触发双击事件
#define UISHORT_TAP_MAX_DELAY 0.25

@implementation YDCoustomTapGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action{
    if (self = [super initWithTarget:target action:action]) {
        _maxSingleTapDalay = UISHORT_TAP_MAX_DELAY;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_maxSingleTapDalay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.state != UIGestureRecognizerStateRecognized){
            self.state = UIGestureRecognizerStateFailed;
        }
    });
}

@end

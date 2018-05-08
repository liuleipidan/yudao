//
//  YDMessageSendIndicatorView.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/14.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMessageSendIndicatorView.h"

@interface YDMessageSendIndicatorView()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation YDMessageSendIndicatorView

- (id)init{
    if (self = [super init]) {
        [self addSubview:_indicatorView];
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)showInView:(UIView *)view style:(UIActivityIndicatorViewStyle )style{
    [self.indicatorView setActivityIndicatorViewStyle:style];
    [view addSubview:self.indicatorView];
    
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

@end

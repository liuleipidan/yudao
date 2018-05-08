//
//  YDDynamicDetailsBottomView.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDDynamicDetailsBottomView.h"

@interface YDDynamicDetailsBottomView()



@end

@implementation YDDynamicDetailsBottomView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)ddb_buttonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicDetailsBottomView:didSelectedBtn:)]) {
        [self.delegate dynamicDetailsBottomView:self didSelectedBtn:sender];
    }
}

- (void)setup{
    self.backgroundColor = [UIColor colorWithString:@"#FAFAFA"];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithString:@"#EBEBEB"];
    [self addSubview:lineView];
    _leftBtn = [YDUIKit buttonWithTitle:@"点赞" image:[UIImage imageNamed:@"dynamic_likeButton_normal"] selectedImage:[UIImage imageNamed:@"dynamic_likeButton_selected"]  target:self];
    _leftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3-1, 46);
    
    _centerBtn = [YDUIKit buttonWithTitle:@"评论" image:[UIImage imageNamed:@"dynamic_button_comment"]  target:self];
    _centerBtn.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3-1, 46);
    
    _rightBtn = [YDUIKit buttonWithTitle:@"分享" image:[UIImage imageNamed:@"dynamic_button_share"]   target:self];
    _rightBtn.frame = CGRectMake(2*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3-1, 46);
    [@[_leftBtn,_centerBtn,_rightBtn] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        btn.tag = 1000+idx;
        [btn setTitleColor:[UIColor blackTextColor] forState:0];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:[UIFont font_12]];
        [btn addTarget:self action:@selector(ddb_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [self addSubview:btn];
    }];
    UIView *leftLine = [YDUIKit viewWithBackgroundColor:[UIColor colorWithString:@"#C7C7CC"]];
    leftLine.frame = CGRectMake(SCREEN_WIDTH/3.0-1, (46-24)/2, 2, 24);
    leftLine.alpha = 0.3;
    UIView *rightLine = [YDUIKit viewWithBackgroundColor:[UIColor colorWithString:@"#C7C7CC"]];
    rightLine.frame = CGRectMake(2.0*SCREEN_WIDTH/3.0-1, (46-24)/2, 2, 24);
    rightLine.alpha = 0.3;
    
    [self yd_addSubviews:@[lineView,leftLine,rightLine]];
}

@end

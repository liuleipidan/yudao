//
//  YDRescueBottomTool.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/10.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDRescueBottomTool.h"

@interface YDRescueBottomTool()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *centerBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation YDRescueBottomTool

- (instancetype)init{
    if (self = [super init]) {
        
        [self initSubviews];
    }
    return self;
}

- (void)btnsAction:(UIButton *)btn{
    NSUInteger index = btn.tag - 1000;
    NSLog(@"index = %lu",index);
    if (self.delegate && [self.delegate respondsToSelector:@selector(rescueBottomTool:selectedBtn:)]) {
        [self.delegate rescueBottomTool:self selectedBtn:btn];
    }
}

- (void)initSubviews{
    self.backgroundColor = [UIColor whiteColor];
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setImage:@"dynamic_likeButton_selected" imageHL:@"dynamic_likeButton_selected"];
    [_leftBtn setTitle:@"帮一帮" forState:0];
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerBtn setImage:@"dynamic_likeButton_selected" imageHL:@"dynamic_likeButton_selected"];
    [_centerBtn setTitle:@"路线导航" forState:0];
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setImage:@"dynamic_likeButton_selected" imageHL:@"dynamic_likeButton_selected"];
    [_rightBtn setTitle:@"点赞" forState:0];
    
    NSArray<UIButton *> *btns = @[_leftBtn,_centerBtn,_rightBtn];
    [self yd_addSubviews:btns];
    [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
    }];
    [btns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = 1000 + idx;
        [obj addTarget:self action:@selector(btnsAction:) forControlEvents:UIControlEventTouchUpInside];
        obj.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [obj setTitleColor:YDColorString(@"#FFFFFF") forState:0];
        obj.titleLabel.font = [UIFont systemFontOfSize:16];
        obj.backgroundColor = YDBaseColor;
    }];
}

@end

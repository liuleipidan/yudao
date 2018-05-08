//
//  YDLCSelectView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/4.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDLCSelectView.h"

@interface YDLCSelectView()

@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *thirdBtn;

@end

@implementation YDLCSelectView

- (instancetype)init{
    if(self = [super init]){
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    UIImageView *bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_lc_bg"]];
    [self addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_firstBtn setImage:@"discover_lc_userLoc" imageHL:@"discover_lc_userLoc"];
    _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_secondBtn setImage:@"discover_lc_carLoc" imageHL:@"discover_lc_carLoc"];
    _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_thirdBtn setImage:@"discover_lc_refresh" imageHL:@"discover_lc_refresh"];
    
    NSArray<UIButton *> *buttons = @[_firstBtn,_secondBtn,_thirdBtn];
    [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = 1000 + idx;
        [obj addTarget:self action:@selector(buttonsActions:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:obj];
    }];
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = YDBaseColor;
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = YDBaseColor;
    [self addSubview:topLine];
    [self addSubview:bottomLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_firstBtn.mas_bottom).offset(-0.5);
        make.bottom.equalTo(_secondBtn.mas_top).offset(0.5);
        make.width.mas_equalTo(27);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_secondBtn.mas_bottom).offset(-0.5);
        make.bottom.equalTo(_thirdBtn.mas_top).offset(0.5);
        make.width.mas_equalTo(27);
    }];
}

- (void)buttonsActions:(UIButton *)button{
    NSInteger index = button.tag - 1000;
    if (self.selectedBlock) {
        self.selectedBlock(index);
    }
}

@end

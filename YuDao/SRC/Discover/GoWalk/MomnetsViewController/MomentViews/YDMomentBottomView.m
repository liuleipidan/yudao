//
//  YDMomentBottomView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentBottomView.h"

@interface YDMomentBottomView()

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIView *verLine1;

@property (nonatomic, strong) UIView *verLine2;

@property (nonatomic,copy) void (^leftBtnBlock )(void);
@property (nonatomic,copy) void (^centerBtnBlock )(void);
@property (nonatomic,copy) void (^rightBtnBlock )(void);

@end

@implementation YDMomentBottomView

- (instancetype)initWithLeftBtnAction:(void (^)(void))leftBtnBlock
                      centerBtnAction:(void (^)(void))centerBtnBlock
                       rightBtnAction:(void (^)(void))rightBtnBlock{
    if (self = [super init]) {
        _leftBtnBlock = leftBtnBlock;
        _centerBtnBlock = centerBtnBlock;
        _rightBtnBlock = rightBtnBlock;
        [self mb_setupSubviews];
        [self mb_addMasonry];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setLeftButtonCount:(NSNumber *)leftCount centerBtnCount:(NSNumber *)centerCount likeState:(NSNumber *)state{
    _leftBtn.selected = state.integerValue == 2;//是否已点赞
    if (leftCount.integerValue != 0) {
        [_leftBtn setTitle:[NSString stringWithFormat:@"点赞·%@",leftCount] forState:0];
    }else{
        [_leftBtn setTitle:@"点赞" forState:0];
    }
    if (centerCount.integerValue != 0) {
        [_centerBtn setTitle:[NSString stringWithFormat:@"评论·%@",centerCount] forState:0];
    }else{
        [_centerBtn setTitle:@"评论" forState:0];
    }
}

#pragma mark - Events
- (void)mb_itemAction:(UIButton *)sender{
    switch (sender.tag - 1000) {
        case 0: self.leftBtnBlock();   break;
        case 1: self.centerBtnBlock(); break;
        case 2: self.rightBtnBlock();  break;
        default:
            break;
    }
}

#pragma mark - Private Methods
- (void)mb_setupSubviews{
    _topLine = [UIView new];
    _topLine.backgroundColor = [UIColor lineColor1];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor lineColor];
    
    _verLine1 = [UIView new];
    _verLine1.backgroundColor = [UIColor lineColor1];
    _verLine2 = [UIView new];
    _verLine2.backgroundColor = [UIColor lineColor1];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setImage:@"dynamic_likeButton_normal" imageSelected:@"dynamic_likeButton_selected"];
    [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_leftBtn setTitle:@"赞" forState:0];
    [_leftBtn setTitleColor:[UIColor blackTextColor] forState:0];
    [_leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerBtn setImage:YDImage(@"dynamic_button_comment") forState:0];
    [_centerBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_centerBtn setTitle:@"评论" forState:0];
    [_centerBtn setTitleColor:[UIColor blackTextColor] forState:0];
    [_centerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setImage:YDImage(@"dynamic_button_share") forState:0];
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_rightBtn setTitle:@"分享" forState:0];
    [_rightBtn setTitleColor:[UIColor blackTextColor] forState:0];
    [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    NSArray<UIButton *> *buttons = @[_leftBtn,_centerBtn,_rightBtn];
    [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
        obj.tag = 1000 + idx;
        [obj addTarget:self action:@selector(mb_itemAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self yd_addSubviews:@[_topLine,_leftBtn,_centerBtn,_rightBtn,_bottomLine,_verLine1,_verLine2]];
}

- (void)mb_addMasonry{
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [_verLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLine.mas_bottom).offset(10);
        make.left.equalTo(self).offset(SCREEN_WIDTH/3.0);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    
    [_verLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLine.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-SCREEN_WIDTH/3.0);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(_verLine1.mas_left);
        make.centerY.equalTo(_verLine1);
        make.height.mas_equalTo(40);
    }];
    
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_verLine1.mas_right);
        make.right.equalTo(_verLine2.mas_left);
        make.centerY.equalTo(_verLine1);
        make.height.mas_equalTo(40);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_verLine1);
        make.left.equalTo(_verLine2.mas_right);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
}


@end

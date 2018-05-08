//
//  YDSectorPopView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/3.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSectorPopView.h"

@interface YDSectorPopView()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *item1;
@property (nonatomic, strong) UIButton *item2;
@property (nonatomic, strong) UIButton *item3;
@property (nonatomic, strong) UIButton *item4;

@property (nonatomic, strong) NSArray<UIButton *> *items;
@end

@implementation YDSectorPopView

- (instancetype)init{
    if(self = [super init]){
        [self initSubviews];
    }
    return self;
}


#pragma mark  - Public Methods
- (void)showItems{
    if (!_show) {
        self.hidden = NO;
        _show = YES;
        [UIView animateWithDuration:0.25 animations:^{
            _bgView.alpha = 1;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [_item1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(kWidth(70));
                    make.bottom.equalTo(self).offset(-20);
                    make.height.width.mas_equalTo(44);
                }];
                [_item4 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-kWidth(70));
                    make.bottom.equalTo(self).offset(-20);
                    make.height.width.mas_equalTo(44);
                }];
                [_item2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_item1.mas_right).offset(5);
                    make.bottom.equalTo(_item1.mas_top).offset(-10);
                    make.height.width.mas_equalTo(44);
                }];
                [_item3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(_item4.mas_left).offset(-5);
                    make.bottom.equalTo(_item4.mas_top).offset(-10);
                    make.height.width.mas_equalTo(44);
                }];
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        //[self layoutIfNeeded];
        
    }
    
}

- (void)hideItems{
    self.hidden = YES;
    _show = NO;
    [_items mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.height.width.mas_equalTo(44);
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - Pirate Methods
- (void)initSubviews{
//    _bgView = [[UIView alloc] init];
//    _bgView.backgroundColor = [UIColor lightGrayColor];
//    _bgView.alpha = 0;
//    [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideItems)]];
//    [self addSubview:_bgView];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideItems)]];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    _item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _item1.backgroundColor = [UIColor orangeColor];
    _item2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _item2.backgroundColor = [UIColor orangeColor];
    _item3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _item3.backgroundColor = [UIColor orangeColor];
    _item4 = [UIButton buttonWithType:UIButtonTypeCustom];
    _item4.backgroundColor = [UIColor orangeColor];
    
    _items = @[_item1,_item2,_item3,_item4];
    [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
        [obj addTarget:self action:@selector(itemActions:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [_items mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.height.width.mas_equalTo(44);
    }];
}

- (void)itemActions:(UIButton *)item{
    [self hideItems];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

@end

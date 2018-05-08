//
//  YDRankListFilterView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/26.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDRankListFilterView.h"
#import "YDRankListFilterButton.h"

@interface YDRankListFilterView()

@property (nonatomic, strong) NSArray<YDRankListFilterButton *> *buttons;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) UILabel *subtitleLabel1;

@property (nonatomic, strong) UILabel *subtitleLabel2;

@property (nonatomic, strong) UIButton *ensureBtn;

//临时条件
@property (nonatomic, assign) YDRankingListFilterCondition tempCondition;

@end


@implementation YDRankListFilterView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor tableViewSectionHeaderViewBackgoundColor];
        
        self.condition = YDRankingListFilterConditionNo;
        
        [self lf_initSubviews];
        [self lf_addMasonry];
        
    }
    return self;
}

#pragma mark  - Events
- (void)lf_filterButtonAction:(YDRankListFilterButton *)btn{
    
    _tempCondition = btn.condition;
    
    [btn setSelected:!btn.isSelected];
    [_buttons enumerateObjectsUsingBlock:^(YDRankListFilterButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != btn) {
            [obj setSelected:NO];
        }
    }];
}

- (void)lf_clearButtonAction:(UIButton *)btn{
    _tempCondition = YDRankingListFilterConditionNo;
    
    [_buttons enumerateObjectsUsingBlock:^(YDRankListFilterButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelected:NO];
    }];
}

- (void)lf_ensureButtonAction:(UIButton *)btn{
    _condition = _tempCondition;
    if (_LFEnsureBlock) {
        _LFEnsureBlock(_tempCondition);
    }
    
}

#pragma mark - Setter
- (void)setCondition:(YDRankingListFilterCondition)condition{
    _condition = condition;
    _tempCondition = condition;
    
    [_buttons enumerateObjectsUsingBlock:^(YDRankListFilterButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.condition == condition) {
            obj.selected = YES;
        }
        else{
            obj.selected = NO;
        }
    }];
}

#pragma mark - Private Methods
- (void)lf_initSubviews{
    
    __block NSMutableArray *tempBtns = [NSMutableArray arrayWithCapacity:5];
    [[self titlesAndIcons] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YDRankingListFilterCondition condition = idx + 1;
        YDRankListFilterButton *btn = [[YDRankListFilterButton alloc] initWithCondition:condition title:[obj valueForKey:@"title"] iconPath:[obj valueForKey:@"iconPath"] iconHLPath:[obj valueForKey:@"iconHLPath"]];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(lf_filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempBtns addObject:btn];
    }];
    
    _buttons = [NSArray arrayWithArray:tempBtns];
    
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:18] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
    _titleLabel.text = @"筛选";
    
    _subtitleLabel1 = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    _subtitleLabel1.text = @"性别";
    
    _subtitleLabel2 = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
    _subtitleLabel2.text = @"其他条件";
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearBtn setTitle:@"清除所有" forState:0];
    [_clearBtn.titleLabel setFont:[UIFont font_12]];
    [_clearBtn setTitleColor:[UIColor baseColor] forState:0];
    [_clearBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_clearBtn addTarget:self action:@selector(lf_clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ensureBtn setTitle:@"确认" forState:0];
    [_ensureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_ensureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_ensureBtn.layer setCornerRadius:8];
    [_ensureBtn setBackgroundColor:[UIColor baseColor]];
    [_ensureBtn.titleLabel setFont:[UIFont font_16]];
    [_ensureBtn addTarget:self action:@selector(lf_ensureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self yd_addSubviews:_buttons];
    [self yd_addSubviews:@[_titleLabel,_subtitleLabel1,_subtitleLabel2,_clearBtn,_ensureBtn]];
}

- (void)lf_addMasonry{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.bottom.equalTo(_titleLabel.mas_bottom);
        make.width.mas_equalTo(68);
    }];
    
    [_subtitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(30);
    }];
    
    NSArray<YDRankListFilterButton *> *topButtons = [_buttons subarrayWithRange:NSMakeRange(0, 2)];
    NSArray<YDRankListFilterButton *> *bottomButtons = [_buttons subarrayWithRange:NSMakeRange(2, _buttons.count-2)];
    
    [topButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subtitleLabel1.mas_bottom).offset(10);
        make.height.mas_equalTo(70);
    }];
    [topButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:3 leadSpacing:10 tailSpacing:10];
    
    [_subtitleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(topButtons.firstObject.mas_bottom).offset(20);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(50);
    }];
    
    [bottomButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subtitleLabel2.mas_bottom).offset(10);
        make.height.mas_equalTo(70);
    }];
    [bottomButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:3 leadSpacing:10 tailSpacing:10];
    
    [_ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(44);
    }];
}

- (NSArray<NSDictionary *> *)titlesAndIcons{
    return @[
             @{@"title":@"女生",@"iconPath":@"discover_rankfilter_female",@"iconHLPath":@"discover_rankfilter_female_HL"},
             @{@"title":@"男生",@"iconPath":@"discover_rankfilter_male",@"iconHLPath":@"discover_rankfilter_male_HL"},
             @{@"title":@"我的好友",@"iconPath":@"discover_rankfilter_friend",@"iconHLPath":@"discover_rankfilter_friend_HL"},
             @{@"title":@"附近的人",@"iconPath":@"discover_rankfilter_nearby",@"iconHLPath":@"discover_rankfilter_nearby_HL"},
             @{@"title":@"同系车友",@"iconPath":@"discover_rankfilter_car",@"iconHLPath":@"discover_rankfilter_car_HL"}
             ];
}

@end

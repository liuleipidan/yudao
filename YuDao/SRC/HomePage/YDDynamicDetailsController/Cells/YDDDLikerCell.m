//
//  YDDDLikerCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDDLikerCell.h"

@interface YDDDLikerCell()

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation YDDDLikerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setClipsToBounds:YES];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self lc_initSubviews];
        [self lc_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setLikePeople:(NSMutableArray<YDTapLikeModel *> *)likePeople{
    if (likePeople.count == 0) {
        _numLabel.text = @"";
        [self.containerView removeAllSubViews];
        return;
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%ld人 点赞",likePeople.count];
    NSArray *tempArray = [[likePeople reverseObjectEnumerator] allObjects];
    if (tempArray.count <= 5) {
        _likePeople = [NSMutableArray arrayWithArray:[tempArray subarrayWithRange:NSMakeRange(0, tempArray.count)]];
    }else{
        _likePeople = [NSMutableArray arrayWithArray:[tempArray subarrayWithRange:NSMakeRange(0, 5)]];
    }
    if ([tempArray.firstObject isEqual:_likePeople.firstObject] && self.containerView.subviews.count == _likePeople.count) {
        [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imgV = obj;
            YDTapLikeModel *model = _likePeople[idx];
            [imgV yd_setImageWithString:model.ud_face placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
        }];
    }
    else{
        [self.containerView removeAllSubViews];
        CGFloat itemWidth = 34.f;
        CGFloat space = 10.f;
        [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_likePeople.count == 1 ? itemWidth : (_likePeople.count-1) * space + _likePeople.count * itemWidth );
        }];
        __block NSMutableArray *itemViews = [NSMutableArray arrayWithCapacity:_likePeople.count];
        [_likePeople enumerateObjectsUsingBlock:^(YDTapLikeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YDTapLikeModel * model = obj;
            UIImageView *imageV = [UIImageView new];
            imageV.aliCornerRadius = 17.0f;
            imageV.tag = idx + 1000;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lc_didTapLikerAvatar:)];
            imageV.userInteractionEnabled = YES;
            [imageV addGestureRecognizer:tap];
            [imageV yd_setImageWithString:model.ud_face placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
            [itemViews addObject:imageV];
        }];
        [_containerView yd_addSubviews:itemViews];
        if (itemViews.count == 1) {
            [itemViews mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_containerView);
            }];
        }else{
            [itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:space leadSpacing:0 tailSpacing:0];
            [itemViews mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(_containerView);
            }];
        }
    }
    
    [self.containerView layoutIfNeeded];
}

#pragma mark - Events
- (void)lc_didTapLikerAvatar:(UIGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(DDlikerCell:didClicedAvatarWithIndex:)]) {
        [_delegate DDlikerCell:self didClicedAvatarWithIndex:tap.view.tag-1000];
    }
}

- (void)lc_arrowButtonAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(DDlikerCell:didClicedAvatarWithIndex:)]) {
        [_delegate DDlikerCell:self didSelectedArrowBtn:sender];
    }
}

#pragma mark - Private Methods
- (void)lc_initSubviews{
    _topLineView = [UIView new];
    _topLineView.backgroundColor = [UIColor grayBackgoundColor];
    
    _numLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _numLabel.text = @"0人 点赞";
    
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    
    _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_arrowBtn setImage:YDImage(@"tableViewCell_arrow_right") forState:0];
    [_arrowBtn addTarget:self action:@selector(lc_arrowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = [UIColor grayBackgoundColor];
    
    [self.contentView yd_addSubviews:@[_topLineView,_numLabel,_containerView,_arrowBtn,_bottomLineView]];
}

- (void)lc_addMasonry{
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_numLabel);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(27, 34));
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_numLabel);
        make.right.equalTo(_arrowBtn.mas_left);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(0);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
}

@end

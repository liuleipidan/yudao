//
//  YDCarsLocationView.m
//  YuDao
//
//  Created by 汪杰 on 16/12/12.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDCarsLocationView.h"

@interface YDCarsLocationView()

@property (nonatomic, strong) UILabel *rankLabel;

@property (nonatomic, strong) UIImageView *rankImagV;

@property (nonatomic, strong) UIButton *switchCarButton;

@end

@implementation YDCarsLocationView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self y_layoutSubviews];
    }
    return self;
}

- (void)updateRankingByTrafficInfoManager:(YDTrafficInfoManager *)manager{
    YDCarDetailModel *curCar = manager.currentCar;
    if (curCar.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR ||
        curCar.boundDeviceType == YDCarBoundDeviceTypeVE_BOX) {
        _rankLabel.text = manager.rank;
        _rankImagV.image = [UIImage imageNamed:manager.rankingImageStr];
    }
    else if (curCar.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        _rankLabel.text = @"";
        _rankImagV.image = nil;
    }
}

#pragma mark - Events
- (void)cl_switchCarButtonAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(carsLocationView:didClickedSwitchWithFrame:)]) {
        CGRect frame = CGRectMake(_carIcon.x, _carIcon.x, CGRectGetMaxX(_switchCarButton.frame) - _carIcon.x, _carIcon.height);
        [self.delegate carsLocationView:self didClickedSwitchWithFrame:frame];
    }
}

- (void)locationBtnAction:(id)locBtn{
    if ([self.delegate respondsToSelector:@selector(carsLocationView:didTouchLocationBtn:)]) {
        [self.delegate carsLocationView:self didTouchLocationBtn:nil];
    }
}

- (void)tapRankAction:(UIGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(carsLocationViewDidTouchRank)]) {
        [self.delegate carsLocationViewDidTouchRank];
    }
}

- (void)y_layoutSubviews{
    [self yd_addSubviews:@[self.carIcon,self.carChooseLabel,self.switchCarButton,self.rankImagV,self.rankLabel]];
    [_carIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.height.mas_equalTo(43);
    }];
    [_carChooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.carIcon.mas_right).offset(12);
        make.height.mas_equalTo(40);
        make.width.mas_lessThanOrEqualTo(kWidth(120));
    }];
    
    [_switchCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.carChooseLabel.mas_right).offset(3);
        make.size.mas_equalTo(CGSizeMake(35,32));
    }];
    
    [_rankImagV mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.right.equalTo(self);
        make.height.width.mas_equalTo(11);
    }];
    
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self);
        make.right.equalTo(self.rankImagV.mas_left).offset(-5);
        make.height.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(150);
    }];
}

- (UIButton *)carIcon{
    if (!_carIcon) {
        _carIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _carIcon;
}

- (UILabel *)carChooseLabel{
    if (!_carChooseLabel) {
        
        _carChooseLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
        
        if ([YDCarHelper sharedHelper].carArray.count > 0) {
            YDCarDetailModel *car = [[YDCarHelper sharedHelper] defaultCar];
            if (car) {
                _carChooseLabel.text = car.ug_series_name;
            }
        }else{
            _carChooseLabel.text = @"暂无车辆";
        }
        _carChooseLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cl_switchCarButtonAction:)];
        [_carChooseLabel addGestureRecognizer:tap];
    }
    return _carChooseLabel;
}

- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14] textAlignment:NSTextAlignmentRight];
        _rankLabel.userInteractionEnabled = YES;
        [_rankLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRankAction:)]];
    }
    return _rankLabel;
}

- (UIImageView *)rankImagV{
    if (!_rankImagV) {
        _rankImagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardriving_rank_normal"]];
        _rankImagV.userInteractionEnabled = YES;
        [_rankImagV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRankAction:)]];
    }
    return _rankImagV;
}


- (UIButton *)switchCarButton{
    if (_switchCarButton == nil) {
        _switchCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCarButton setImage:YDImage(@"cardriving_chooseBtn") forState:0];
        [_switchCarButton addTarget:self action:@selector(cl_switchCarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCarButton;
}

@end

//
//  YDWeatherHeaderView.m
//  YuDao
//
//  Created by 汪杰 on 2018/5/5.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDWeatherHeaderView.h"

@interface YDWeatherHeaderView ()

//背景
@property (nonatomic, strong) UIImageView *backgroundImageView;

//当前温度
@property (nonatomic, strong) UILabel *currentTemLabel;

//当前温度单位
@property (nonatomic, strong) UILabel *currentTemUnitLabel;

//今日天气图标
@property (nonatomic, strong) UIImageView *todayWeatherIcon;

//气温标题
@property (nonatomic, strong) UILabel *weatherTemTitleLabel;

//气温
@property (nonatomic, strong) UILabel *weatherTemLabel;

//气温单位
@property (nonatomic, strong) UILabel *weatherUnitLabel;

//空气指数标题
@property (nonatomic, strong) UILabel *airIndexTitleLabel;

//空气指数
@property (nonatomic, strong) UILabel *airIndexLabel;

//空气指数等级
@property (nonatomic, strong) UILabel *airIndexGradeLabel;

//垂直分割线
@property (nonatomic, strong) UIImageView *verSeparatorImageView;

//水平分割线
@property (nonatomic, strong) UIImageView *horSeparatorImageView;

@end

@implementation YDWeatherHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self wh_initSubviews];
        [self wh_addMasonry];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)setModel:(YDWeatherModel *)model{
    _model = model;
    
    _currentTemLabel.text = model.nowTemperature;
    
    _weatherTemLabel.text = model.todayTemperatureRange;
    
    _airIndexLabel.text = [NSString stringWithFormat:@"%@",model.airQualityExponent];
    _airIndexGradeLabel.text = model.airQuality;
    
    
    NSString *weatherImageName = [self.model.nowWeatherCode weatherImagePathByWeatherCode:self.model.nowWeatherCode];
    _backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_bg",weatherImageName]];
    _todayWeatherIcon.image = [UIImage imageNamed:weatherImageName];
}

#pragma mark - Private Methods
- (void)wh_initSubviews{
    _backgroundImageView = [UIImageView new];
    _backgroundImageView.backgroundColor = [UIColor whiteColor];
    
    _currentTemLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:120]];
    
    _currentTemUnitLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:30]];
    _currentTemUnitLabel.text = @"℃";
    
    _todayWeatherIcon = [UIImageView new];
    
    _weatherTemTitleLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_14]];
    _weatherTemTitleLabel.text = @"今日气温";
    
    _weatherTemLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:30]];
    
    _weatherUnitLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_16]];
    _weatherUnitLabel.text = @"℃";
    
    _airIndexTitleLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_14]];
    _airIndexTitleLabel.text = @"空气指数";
    
    _airIndexLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:30]];
    
    _airIndexGradeLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_16]];
    
    _verSeparatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weather_verLine"]];
    
    _horSeparatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weather_horLine"]];
    
    [self yd_addSubviews:@[
                           _backgroundImageView,
                           _currentTemLabel,
                           _currentTemUnitLabel,
                           _todayWeatherIcon,
                           _weatherTemTitleLabel,
                           _weatherTemLabel,
                           _weatherUnitLabel,
                           _airIndexTitleLabel,
                           _airIndexLabel,
                           _airIndexGradeLabel,
                           _verSeparatorImageView,
                           _horSeparatorImageView
                           ]];
}

- (void)wh_addMasonry{
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
        //make.top.equalTo(self).offset(-STATUSBAR_HEIGHT);
    }];
    
    [_verSeparatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 104));
    }];
    
    [_horSeparatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.verSeparatorImageView.mas_top).offset(-1);
        make.height.mas_equalTo(1);
    }];
    
    [_currentTemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.horSeparatorImageView.mas_top).offset(-15);
        make.height.mas_lessThanOrEqualTo(120);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_currentTemUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTemLabel.mas_right).offset(5);
        make.top.equalTo(self.currentTemLabel.mas_top).offset(10);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(40, 40));
    }];
    
    [_todayWeatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTemLabel.mas_right).offset(5);
        make.bottom.equalTo(self.currentTemLabel.mas_bottom).offset(-18);
        make.width.height.mas_equalTo(40);
    }];
    
    [_weatherTemTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self.verSeparatorImageView.mas_left).offset(-16);
        make.top.equalTo(self.horSeparatorImageView.mas_bottom).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    [_weatherTemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weatherTemTitleLabel);
        make.top.equalTo(self.weatherTemTitleLabel.mas_bottom).offset(10);
        make.height.mas_lessThanOrEqualTo(37);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_weatherUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weatherTemLabel.mas_top).offset(3);
        make.left.equalTo(self.weatherTemLabel.mas_right).offset(1);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(20, 20));
    }];
    
    [_airIndexTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weatherTemTitleLabel);
        make.left.equalTo(self.verSeparatorImageView.mas_right).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.mas_equalTo(20);
    }];
    
    [_airIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.airIndexTitleLabel);
        make.top.bottom.equalTo(self.weatherTemLabel);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_airIndexGradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weatherUnitLabel.mas_top);
        make.left.equalTo(self.airIndexLabel.mas_right).offset(1);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(40, 40));
    }];
    
}

@end

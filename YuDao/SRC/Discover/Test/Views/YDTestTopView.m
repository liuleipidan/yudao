//
//  YDTestTopView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/22.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestTopView.h"
#import "YDPercentLabel.h"
#import "YDTestOBDStatusView.h"
#import "YDTestCircleAnimationView.h"
#import "YDBluetoothConfig.h"

@interface YDTestTopView ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *percentLabel;

@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, strong) UILabel *percentStateLabel;

@property (nonatomic, strong) YDPercentLabel *percentAnimation;

@property (nonatomic, strong) YDTestOBDStatusView *statusView;

@property (nonatomic, strong) YDTestCircleAnimationView *animationView;

@end

@implementation YDTestTopView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self tt_initSubviews];
        [self tt_LayoutSubviews];
        
        //接收蓝牙状态改变
        [YDNotificationCenter addObserver:self selector:@selector(ta_bluetoothStateChanged:) name:kBluetoothStateChangedKey object:nil];
        
        //接收VE-AIR数据
        [YDNotificationCenter addObserver:self selector:@selector(ta_receiveVEAIRData:) name:kVE_AIR_DataKey object:nil];
    }
    return self;
}

- (void)dealloc{
    [YDNotificationCenter removeObserver:self name:kBluetoothStateChangedKey object:nil];
    [YDNotificationCenter removeObserver:self name:kVE_AIR_DataKey object:nil];
}
#pragma mark - Notificatoins
- (void)ta_bluetoothStateChanged:(NSNotification *)noti{
    if (self.carInfo.boundDeviceType != YDCarBoundDeviceTypeVE_AIR) {
        return;
    }
    if ([(NSNumber *)noti.object integerValue] == YDBluetoothStateConnected) {
        self.percentLabel.text = @"—";
    }
    else{
        self.percentLabel.text = @"蓝牙未连接";
    }
}
- (void)ta_receiveVEAIRData:(NSNotification *)noti{
    if (self.carInfo.boundDeviceType != YDCarBoundDeviceTypeVE_AIR) {
        return;
    }
    NSInteger aqi = [(NSNumber *)noti.object integerValue];
    if (aqi >= 500) {
        aqi = 400;
    }
    NSString *indexString = @"";
    if (aqi <= 50) {
        indexString = @"优";
    }
    else if (aqi > 50 && aqi <= 100){
        indexString = @"良";
    }
    else if (aqi > 100 && aqi <= 150){
        indexString = @"轻度";
    }
    else if (aqi > 150 && aqi <= 200){
        indexString = @"中度";
    }
    else if (aqi > 200 && aqi <= 300){
        indexString = @"重度";
    }
    else if (aqi > 300 && aqi <= 500){
        indexString = @"极度";
    }
    if (indexString.length == 2) {
        [self.percentLabel setFont:[UIFont systemFontOfSize:48]];
    }
    else{
        [self.percentLabel setFont:[UIFont systemFontOfSize:68]];
    }
    self.percentLabel.text = indexString;
}
#pragma mark - Public Methods
- (void)setCarInfo:(YDCarDetailModel *)carInfo{
    _carInfo = carInfo;
    if (carInfo.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR ||
        carInfo.boundDeviceType == YDCarBoundDeviceTypeVE_BOX) {
        _percentLabel.text = @"0";
        _percentStateLabel.text = @"车况良好";
        _unitLabel.text = @"分";
        _statusView.hidden = NO;
        [self.percentLabel setFont:[UIFont systemFontOfSize:68]];
        self.height = 340;
    }
    else if (carInfo.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        _percentLabel.text = @"—";
        _percentStateLabel.text = @"车内AQI等级";
        _unitLabel.text = @"";
        _statusView.hidden = YES;
        self.height = 305;
    }
    
}
- (void)startAnimationByPercent:(NSInteger)percent isOpen:(BOOL)isOpen{
    
    if (self.carInfo.isBound_BOX) {
        _percentAnimation = [[YDPercentLabel alloc] initWithObject:self.percentLabel key:@"attributedText" from:0 to:percent duration:1.0];
        
        [_percentAnimation start];
        
        [_animationView setProgress:percent/100.0 animated:YES];
        
        [_statusView showByOBDStatus:isOpen];
    }
    
}


#pragma mark - Private Methods
- (void)tt_initSubviews{
    _bgImageView = [[UIImageView alloc] initWithImage:YDImage(@"test_header_bg")];
    _bgImageView.backgroundColor = [UIColor baseColor];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _statusView = [YDTestOBDStatusView new];
    
    _percentLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:68] textAlignment:NSTextAlignmentCenter];
    _percentLabel.adjustsFontSizeToFitWidth = YES;
    _percentLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    _unitLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_12] textAlignment:0];
    _unitLabel.text = @"分";
    
    _percentStateLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_14] textAlignment:NSTextAlignmentCenter];
    _percentStateLabel.text = @"车况良好";
    
    _animationView = [[YDTestCircleAnimationView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 52, 200, 200)];
    [_animationView setBackgroundStrokeColor:[UIColor lightGrayColor]];
    [_animationView setProgressStrokeColor:[UIColor whiteColor]];
    
    [self yd_addSubviews:@[_bgImageView,_statusView,_animationView,_percentLabel,_unitLabel,_percentStateLabel]];
}

- (void)tt_LayoutSubviews{
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(305);
    }];
    
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(-30);
        make.height.mas_equalTo(60);
    }];
    
    [_percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.animationView);
        make.width.mas_lessThanOrEqualTo(140);
        make.height.mas_equalTo(55);
    }];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.percentLabel.mas_bottom);
        make.left.equalTo(self.percentLabel.mas_right).offset(2);
        make.size.mas_equalTo(CGSizeMake(50, 17));
    }];
    
    [_percentStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.percentLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self);
        make.height.mas_lessThanOrEqualTo(20);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
}

@end

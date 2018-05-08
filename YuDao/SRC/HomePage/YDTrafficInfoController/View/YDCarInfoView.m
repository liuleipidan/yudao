//
//  YDCarInfoView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/25.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCarInfoView.h"
#import "YDBluetoothConfig.h"

@interface YDCarInfoView()

@property (nonatomic, strong) UILabel *topTitleLabel;

@property (nonatomic, strong) UILabel *topDataLabel;

@property (nonatomic, strong) UILabel *leftTitleLabel;

@property (nonatomic, strong) UILabel *leftDataLabel;

@property (nonatomic, strong) UILabel *centerTitleLabel;

@property (nonatomic, strong) UILabel *centerDataLabel;

@property (nonatomic, strong) UILabel *rightTitleLabel;

@property (nonatomic, strong) UILabel *rightDataLabel;

@property (nonatomic, strong) UIImageView *line;

//监听蓝牙状态
@property (nonatomic, strong) id bluetoothStateObserver;

//监听空静数据
@property (nonatomic, strong) id airDataObserver;

@end

@implementation YDCarInfoView

- (instancetype)init{
    if (self = [super init]) {
        
        [self initSubviews];
        [self addMasonry];
        
    }
    return self;
}

- (void)updateUIByTrafficInfoManager:(YDTrafficInfoManager *)manager{
    YDCarDetailModel *curCar = manager.currentCar;
    NSLog(@"curCar.boundDeviceType = %ld",curCar.boundDeviceType);
    /*
     根据车辆的绑定状态不同，将显示三种不同的UI
     */
    if (curCar.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR) {
        _topTitleLabel.text = @"车辆健康值";
        _leftTitleLabel.text = @"本周里程";
        _centerTitleLabel.text = @"本周耗油";
        _rightTitleLabel.text = @"车内AQI";
        
        //等到蓝牙数据返回
        _rightDataLabel.text = @"-";
        [self setScore:manager.score];
    }
    else if (curCar.boundDeviceType == YDCarBoundDeviceTypeVE_BOX ||
             curCar.boundDeviceType == YDCarBoundDeviceTypeNone){
        _topTitleLabel.text = @"车辆健康值";
        _leftTitleLabel.text = @"本周里程";
        _centerTitleLabel.text = @"";
        _centerDataLabel.text = @"";
        _rightTitleLabel.text = @"本周耗油";
        [self setScore:manager.score];
        
    }
    else if (curCar.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        _topTitleLabel.text = @"车内AQI等级";
        _leftTitleLabel.text = @"车外AQI";
        _rightTitleLabel.text = @"车内AQI";
        _centerTitleLabel.text = @"";
        //等待蓝牙数据返回
        _rightDataLabel.text = @"—";
    }
    
    /*
     根据车辆的绑定状态不同，将添加或移除蓝牙和空静的数据通知
     */
    [self ci_addOrRemoveAirNotificationByBoundDeviceType:curCar.boundDeviceType];
}

- (void)updateDataByTrafficInfoManager:(YDTrafficInfoManager *)manager{
    YDCarDetailModel *curCar = manager.currentCar;
    YDLog(@"curCar.boundDeviceType = %ld",curCar.boundDeviceType);
    /*
     根据车辆的绑定状态不同，将显示三种不同的UI
     */
    if (curCar.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR) {
        
        [self setMileage:manager.mileage];
        [self setOilwear:manager.oilwear];
    }
    else if (curCar.boundDeviceType == YDCarBoundDeviceTypeVE_BOX ||
             curCar.boundDeviceType == YDCarBoundDeviceTypeNone){
        
        [self setMileage:manager.mileage];
        [self setOilwear:manager.oilwear];
        
    }
    else if (curCar.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        
        _leftDataLabel.text = manager.outsideAQI;
    }
}

- (void)updateDataAndUIByTrafficInfoManager:(YDTrafficInfoManager *)manager{
    YDCarDetailModel *curCar = manager.currentCar;
    YDLog(@"curCar.boundDeviceType = %ld",curCar.boundDeviceType);
    /*
     根据车辆的绑定状态不同，将显示三种不同的UI
     */
    if (curCar.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR) {
        _topTitleLabel.text = @"车辆健康值";
        _leftTitleLabel.text = @"本周里程";
        _centerTitleLabel.text = @"本周耗油";
        _rightTitleLabel.text = @"车内AQI";
        
        [self setMileage:manager.mileage];
        [self setOilwear:manager.oilwear];
        //等到蓝牙数据返回
        _rightDataLabel.text = @"0";
        
    }
    else if (curCar.boundDeviceType == YDCarBoundDeviceTypeVE_BOX ||
             curCar.boundDeviceType == YDCarBoundDeviceTypeNone){
        _topTitleLabel.text = @"车辆健康值";
        _leftTitleLabel.text = @"本周里程";
        _centerTitleLabel.text = @"";
        _centerDataLabel.text = @"";
        _rightTitleLabel.text = @"本周耗油";
        
        [self setMileage:manager.mileage];
        [self setOilwear:manager.oilwear];
        
    }
    else if (curCar.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        _topTitleLabel.text = @"车内AQI等级";
        _leftTitleLabel.text = @"车外AQI";
        _centerTitleLabel.text = @"";
        _rightTitleLabel.text = @"车内AQI";
        
        _leftDataLabel.text = manager.outsideAQI;
        //等待蓝牙数据返回
        _rightDataLabel.text = @"—";
        
    }
    
    /*
     根据车辆的绑定状态不同，将添加或移除蓝牙和空静的数据通知
     */
    [self ci_addOrRemoveAirNotificationByBoundDeviceType:curCar.boundDeviceType];
}

//添加或移除空静的监听
- (void)ci_addOrRemoveAirNotificationByBoundDeviceType:(YDCarBoundDeviceType)type{
    if (type == YDCarBoundDeviceTypeBOX_AIR ||
        type == YDCarBoundDeviceTypeVE_AIR) {
        YDWeakSelf(self);
        if (_bluetoothStateObserver == nil) {
            _bluetoothStateObserver = [YDNotificationCenter addObserverForName:kBluetoothStateChangedKey object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                if (type == YDCarBoundDeviceTypeVE_AIR) {
                    if ([(NSNumber *)note.object integerValue] == YDBluetoothStateConnected) {
                        weakself.topDataLabel.text = @"—";
                        weakself.topTitleLabel.text = @"车内AQI等级";
                    }
                    else{
                        weakself.topDataLabel.text = @"蓝牙未连接";
                        weakself.topTitleLabel.text = @"";
                    }
                }
            }];
        }
        
        if (_airDataObserver == nil) {
            _airDataObserver = [YDNotificationCenter addObserverForName:kVE_AIR_DataKey object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                weakself.topDataLabel.text = [YDBluetoothDataModel VE_AIR_AQIGrade:[(NSNumber *)note.object integerValue]];
                weakself.rightDataLabel.text = [NSString stringWithFormat:@"%@",note.object];
            }];
        }
    }
    else{
        if (_bluetoothStateObserver) {
            [YDNotificationCenter removeObserver:_bluetoothStateObserver];
            _bluetoothStateObserver = nil;
        }
        if (_airDataObserver) {
            [YDNotificationCenter removeObserver:_airDataObserver];
            _airDataObserver = nil;
        }
    }
}

#pragma mark - Setters
- (void)setScore:(NSString *)score{
    NSLog(@"%s score = %@",__func__,score);
    _topDataLabel.text = score;
}

- (void)setMileage:(NSString *)mileage{
    NSMutableAttributedString *atri = [self setAttributedText:mileage lastLength:2];
    [_leftDataLabel setAttributedText:atri];
}

- (void)setOilwear:(NSString *)oilwear{
    NSMutableAttributedString *atri = [self setAttributedText:oilwear lastLength:1];
    [_rightDataLabel setAttributedText:atri];
}

- (void)clickTestView:(UIGestureRecognizer *)ges{
    if (self.delegate && [self.delegate respondsToSelector:@selector(carInfoViewClickTest)]) {
        [self.delegate carInfoViewClickTest];
    }
}
- (void)clickMileageView:(UIGestureRecognizer *)ges{
    if (self.delegate && [self.delegate respondsToSelector:@selector(carInfoViewClickMileage)]) {
        [self.delegate carInfoViewClickMileage];
    }
}
- (void)clickOilwearView:(UIGestureRecognizer *)ges{
    if (self.delegate && [self.delegate respondsToSelector:@selector(carInfoViewClickOilwear)]) {
        [self.delegate carInfoViewClickOilwear];
    }
}

#pragma mark - Private Methods
- (NSMutableAttributedString *)setAttributedText:(NSString *)str lastLength:(NSUInteger )length{
    NSMutableAttributedString *atri = [[NSMutableAttributedString alloc] initWithString:str];
    [atri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(str.length-length, length)];
    [atri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Regular" size:20] range:NSMakeRange(0, str.length-length)];
    return atri;
}

- (void)initSubviews{
    _topDataLabel = [YDUIKit labelTextColor:[UIColor blackTextColor] fontSize:48 textAlignment:NSTextAlignmentCenter];
    _topDataLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:48];
    [_topDataLabel setAdjustsFontSizeToFitWidth:YES];
    
    _topTitleLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
    _topTitleLabel.text = @"车况健康值";
    
    _leftTitleLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:11] textAlignment:0 backgroundColor:[UIColor whiteColor]];
    _leftTitleLabel.text = @"本周里程";
    
    _leftDataLabel = [YDUIKit labelTextColor:[UIColor blackTextColor] fontSize:20 textAlignment:NSTextAlignmentLeft];
    [self setMileage:@"0KM"];
    
    _centerTitleLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
    _centerTitleLabel.text = @"本周里程";
    
    _centerDataLabel = [YDUIKit labelTextColor:[UIColor blackTextColor] fontSize:20 textAlignment:NSTextAlignmentCenter];
    _centerDataLabel.text = @"";
    
    _rightTitleLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentRight backgroundColor:[UIColor whiteColor]];
    _rightTitleLabel.text = @"本周耗油";
    
    _rightDataLabel = [YDUIKit labelTextColor:[UIColor blackTextColor] fontSize:20 textAlignment:NSTextAlignmentRight];
    [self setOilwear:@"0L"];
    
    _line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardriving_separator_line"]];
    [self yd_addSubviews:@[_line,_topTitleLabel,_topDataLabel,
                           _leftTitleLabel,_leftDataLabel,
                           _centerTitleLabel,_centerDataLabel,
                           _rightTitleLabel,_rightDataLabel]];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = YES;
    }];
    
    [_topTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTestView:)]];
    [_topDataLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTestView:)]];
    [_leftTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMileageView:)]];
    [_leftDataLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMileageView:)]];
    [_rightTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOilwearView:)]];
    [_rightDataLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOilwearView:)]];
}

- (void)addMasonry{
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    [_topDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 70));
    }];
    [_topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topDataLabel);
        make.top.equalTo(self.topDataLabel.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 21));
    }];
    
    [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.bottom.equalTo(self.line.mas_top);
        make.height.mas_equalTo(16);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    [_leftDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLabel);
        make.bottom.equalTo(self.leftTitleLabel.mas_top).offset(-8);
        make.size.mas_equalTo(CGSizeMake(100, 21));
    }];
    
    [_centerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.leftTitleLabel);
        make.height.mas_equalTo(16);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    
    [_centerDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.leftDataLabel);
        make.height.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line);
        make.bottom.equalTo(self.line.mas_top);
        make.height.mas_equalTo(16);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    [_rightDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightTitleLabel);
        make.centerY.equalTo(self.leftDataLabel);
        make.size.mas_equalTo(CGSizeMake(100, 21));
    }];
    
}



@end

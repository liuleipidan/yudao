//
//  YDTestAQICell.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestAQICell.h"
#import "YDBluetoothConfig.h"

@interface YDTestAQICell ()

@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *goLabel;

@property (nonatomic, strong) UIImageView *progressImageView;

@property (nonatomic, strong) UIButton *indexButton;

@end

@implementation YDTestAQICell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bgImageView setImage:YDImage(@"test_AQI_bg")];
        
        self.titleLabel.text = @"车内AQI";
        
        [self ta_initSubviews];
        [self ta_addMasonry];
        
        //接收蓝牙状态改变
        [YDNotificationCenter addObserver:self selector:@selector(ta_bluetoothStateChanged:) name:kBluetoothStateChangedKey object:nil];
        
        //接收VE-AIR数据
        [YDNotificationCenter addObserver:self selector:@selector(ta_receiveVEAIRData:) name:kVE_AIR_DataKey object:nil];
    }
    return self;
}

- (void)dealloc{
    YDLog();
    [YDNotificationCenter removeObserver:self name:kBluetoothStateChangedKey object:nil];
    [YDNotificationCenter removeObserver:self name:kVE_AIR_DataKey object:nil];
}

#pragma mark - Public Methods
- (void)setState:(YDTestAQICellState)state{
    _state = state;
    if (state == YDTestAQICellStateBound) {
        _indexButton.hidden = _progressImageView.hidden = NO;
        _goLabel.hidden = _subTitleLabel.hidden = YES;
    }
    else{
        _indexButton.hidden = _progressImageView.hidden = YES;
        _goLabel.hidden = _subTitleLabel.hidden = NO;
    }
}

#pragma mark - Notificatoins
- (void)ta_bluetoothStateChanged:(NSNotification *)noti{
    if ([(NSNumber *)noti.object integerValue] == YDBluetoothStateConnected) {
        _promptLabel.text = @"(31天后需要换过滤网)";
        _indexButton.hidden = NO;
    }
    else{
        _promptLabel.text = @"(VE-AIR蓝牙未连接)";
        _indexButton.hidden = YES;
    }
}
- (void)ta_receiveVEAIRData:(NSNotification *)noti{
    YDLog(@"noti.object = %@",noti.object);
    if (_state != YDTestAQICellStateBound) {
        return;
    }
    NSInteger aqi = [(NSNumber *)noti.object integerValue];
    if (aqi >= 500) {
        aqi = 400;
    }
    NSString *indexString = @"";
    NSString *indexImagePath = @"test_AQI_index1";
    if (aqi <= 50) {
        indexString = @"优";
        indexImagePath = @"test_AQI_index1";
    }
    else if (aqi > 50 && aqi <= 100){
        indexString = @"良";
        indexImagePath = @"test_AQI_index2";
    }
    else if (aqi > 100 && aqi <= 150){
        indexString = @"轻度污染";
        indexImagePath = @"test_AQI_index3";
    }
    else if (aqi > 150 && aqi <= 200){
        indexString = @"中度污染";
        indexImagePath = @"test_AQI_index4";
    }
    else if (aqi > 200 && aqi <= 300){
        indexString = @"重度污染";
        indexImagePath = @"test_AQI_index5";
    }
    else if (aqi > 300 && aqi <= 500){
        indexString = @"极度污染";
        indexImagePath = @"test_AQI_index6";
    }
    UIImage *image = [UIImage imageNamed:indexImagePath];
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 1, 20, 1) resizingMode:UIImageResizingModeStretch];
    [_indexButton setBackgroundImage:newImage forState:0];
    
    [_indexButton setTitle:indexString forState:0];
    _indexButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    CGFloat width = [indexString yd_stringWidthBySize:CGSizeMake(CGFLOAT_MAX, 40) font:[UIFont font_16]] + 20;
    //优、良、轻度、中度、重度、极度
    CGFloat rate = aqi / 500.0f;
    CGFloat offsetX = rate * (SCREEN_WIDTH - 70);
    [self.indexButton mas_updateConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.progressImageView.mas_left).offset(offsetX);
        make.width.mas_equalTo(width);
    }];
}

#pragma mark - Private Methods
- (void)ta_didClickedGoLabel:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(testAQICellDidClickedBuyVe_AIR:)]) {
        [self.delegate testAQICellDidClickedBuyVe_AIR:self];
    }
}
- (void)ta_initSubviews{
    _promptLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_12]];
    _promptLabel.text = @"(31天后需要换过滤网)";
    
    _subTitleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
    _subTitleLabel.text = @"该功能需安装VE-BOX车内空气净化器";
    
    _goLabel = [UILabel labelByTextColor:[UIColor orangeTextColor] font:[UIFont font_16]];
    _goLabel.text = @"点击前往商城购买>>";
    _goLabel.userInteractionEnabled = YES;
    _goLabel.highlightedTextColor = [UIColor shadowColor];
    [_goLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ta_didClickedGoLabel:)]];
    
    _progressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_AQI_progress"]];
    
    _indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _indexButton.hidden = YES;
    //文字偏移，适应背景图片
    _indexButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 0);
    
    [self.contentView yd_addSubviews:@[_promptLabel,_subTitleLabel,_goLabel,_progressImageView,_indexButton]];
}

- (void)ta_addMasonry{
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel.mas_bottom).offset(-4);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.height.mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(21);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(250);
    }];
    
    [_goLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(170);
    }];
    
    [_progressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(35);
        make.right.equalTo(self.contentView).offset(-35);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    [_indexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.progressImageView.mas_top).offset(-2);
        make.left.equalTo(self.progressImageView.mas_left).offset(35);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
}

@end

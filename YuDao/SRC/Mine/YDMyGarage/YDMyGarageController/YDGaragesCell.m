//
//  YDGaragesCell.m
//  YuDao
//
//  Created by 汪杰 on 17/1/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDGaragesCell.h"

@implementation YDGaragesCell
{
    UIButton *_authBtn;
    UIButton *_checkBtn;
    UIButton *_bindBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        
        [self y_layoutSubviews];
    }
    return self;
}

- (void)setModel:(YDCarDetailModel *)model{
    _model = model;
    
    _seriesLabel.text = model.ug_series_name;
    
    NSInteger authStatus = model.ug_vehicle_auth.integerValue;
    //左上角认证状态图片
    NSString *authImageString = @"mine_garage_noAuth";
    if (authStatus == 1) {
        authImageString = @"mine_garage_authed";
    }
    else if (authStatus == 2){
        authImageString = @"mine_garage_authing";
    }
    else if (authStatus == 3){
        authImageString = @"mine_garage_authFail";
    }
    _authImageV.image = YDImage(authImageString);
    
    //按钮
    [_buttonsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    BOOL bindButtonShow = (model.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR);
    if (authStatus != 1 && bindButtonShow) {
        [_buttonsView addSubview:_authBtn];
        [_authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.bottom.equalTo(self.buttonsView);
            make.width.mas_equalTo(83);
        }];
    }
    else if (authStatus != 1 && !bindButtonShow){
        [_buttonsView yd_addSubviews:@[_authBtn,_bindBtn]];
        [_authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.buttonsView);
            make.width.mas_equalTo(83);
        }];
        [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.buttonsView);
            make.width.mas_equalTo(83);
        }];
    }
    else if (authStatus == 1 && !bindButtonShow){
        [_buttonsView yd_addSubviews:@[_checkBtn,_bindBtn]];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.buttonsView);
            make.width.mas_equalTo(83);
        }];
        [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.buttonsView);
            make.width.mas_equalTo(83);
        }];
    }
    else if (authStatus == 1 && bindButtonShow){
        [_buttonsView addSubview:_checkBtn];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.bottom.equalTo(self.buttonsView);
            make.width.mas_equalTo(83);
        }];
    }
    
    //中间提示Icon、文字和文字颜色
    NSString *promptIconPath = model.boundDeviceType == YDCarBoundDeviceTypeNone ? @"mine_garage_prompt_noAuth" : @"mine_garage_prompt_authed";
    NSString *promptTitle = @"";
    UIColor  *promptColor = model.boundDeviceType == YDCarBoundDeviceTypeNone ? [UIColor orangeTextColor] : [UIColor greenTextColor];
    
    //绑定按钮标题
    NSString *bindButonTitle = @"";
    
    if (model.boundDeviceType == YDCarBoundDeviceTypeNone) {
        promptTitle = @"尚未绑定任何设备";
        bindButonTitle = @"绑定设备";
    }
    else if (model.boundDeviceType == YDCarBoundDeviceTypeVE_AIR){
        promptTitle = @"已绑定VE-AIR";
        bindButonTitle = @"绑定VE-BOX";
    }
    else if (model.boundDeviceType == YDCarBoundDeviceTypeVE_BOX){
        promptTitle = @"已绑定VE-BOX";
        bindButonTitle = @"绑定VE-AIR";
    }
    else if (model.boundDeviceType == YDCarBoundDeviceTypeBOX_AIR){
        promptTitle = @"可通过\"测一测\"查看车况";
        bindButonTitle = @"";
    }
    [_promptBtn setImage:YDImage(promptIconPath) forState:0];
    [_promptBtn setTitle:promptTitle forState:0];
    [_promptBtn setTitleColor:promptColor forState:0];
    [_bindBtn setTitle:bindButonTitle forState:0];
}

//创建并添加button到_buttonsView
- (UIButton *)createOptionalButtonTitle:(NSString *)title
                                 AtView:(UIView *)view{
    UIColor *color = YDBaseColor;
    UIButton *button = [YDUIKit buttonWithTitle:title titleColor:color   target:self];
    [button.titleLabel setFont:[UIFont font_14]];
    button.layer.cornerRadius = 8.f;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = color.CGColor;
    [button addTarget:self action:@selector(optionalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return button;
}

- (void)y_layoutSubviews{
    [self.contentView addSubview:self.backgView];
    [_backgView sd_addSubviews:@[self.authImageV,self.seriesLabel,self.buttonsView,self.deleteButton,self.promptBtn]];
    
    [_backgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(7, 9, 7, 9));
    }];
    
    [_authImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backgView);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];

    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.backgView);
        make.width.height.mas_equalTo(35);
    }];

    [_seriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgView).offset(23);
        make.left.equalTo(self.backgView).offset(50);
        make.right.equalTo(self.backgView).offset(-50);
        make.height.mas_equalTo(24);
    }];
    
    [_buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgView);
        make.height.mas_equalTo(26);
        make.bottom.equalTo(self.backgView).offset(-11);
        make.width.mas_equalTo(180);
    }];
    
    [_promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seriesLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.buttonsView.mas_top).offset(-5);
        make.centerX.equalTo(self.backgView);
        make.width.lessThanOrEqualTo(self.backgView.mas_width);
    }];
}
//点击删除按钮
- (void)deleteCarButtonAction:(UIButton *)sender{
    if (self.garagesCellDeleteCarBlock) {
        self.garagesCellDeleteCarBlock(self.model);
    }
}
//点击中间可变按钮
- (void)optionalButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(garagesCell:didTouchButton:)]) {
        [self.delegate garagesCell:self didTouchButton:sender];
    }
}

#pragma mark - Getters
- (UIView *)backgView{
    if (!_backgView) {
        _backgView = [[UIView alloc] init];
        _backgView.backgroundColor = [UIColor whiteColor];
        _backgView.layer.cornerRadius = 8.0f;
        _backgView.layer.shadowColor = [UIColor colorWithString:@"#B6C5DC"].CGColor;
        _backgView.layer.shadowRadius = 6.f;
        _backgView.layer.shadowOpacity = 1;
        _backgView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    }
    return _backgView;
}

- (UIImageView *)authImageV{
    if (!_authImageV) {
        _authImageV = [[UIImageView alloc] init];
    }
    return _authImageV;
}

- (UILabel *)seriesLabel{
    if (!_seriesLabel) {
        _seriesLabel = [YDUIKit labelTextColor:YDBaseColor fontSize:14 textAlignment:NSTextAlignmentCenter];
    }
    return _seriesLabel;
}

- (UIView *)buttonsView{
    if (!_buttonsView) {
        _buttonsView = [[UIView alloc] init];
        _authBtn = [self createOptionalButtonTitle:@"车辆认证" AtView:_buttonsView];
        _checkBtn = [self createOptionalButtonTitle:@"违章查询" AtView:_buttonsView];
        _bindBtn = [self createOptionalButtonTitle:@"绑定VE-BOX" AtView:_buttonsView];
    }
    return _buttonsView;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [YDUIKit buttonWithImage:[UIImage imageNamed:@"mine_garage_deleteCar"] selectedImage:nil selector:@selector(deleteCarButtonAction:)   target:self];
        [_deleteButton setImage:[UIImage imageNamed:@"mine_garage_deleteCar"] forState:UIControlStateHighlighted];
    }
    return _deleteButton;
}

- (UIButton *)promptBtn{
    if (!_promptBtn) {
        _promptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_promptBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _promptBtn.enabled = NO;
        [_promptBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    }
    return _promptBtn;
}


@end

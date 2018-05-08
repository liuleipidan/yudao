//
//  YDAuthenticateCell.m
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAuthenticateCell.h"

@interface YDAuthenticateCell()

@property (nonatomic, strong) UIImageView *flowerImageV;

@property (nonatomic, strong) UILabel    *titleLabel;

/**
 点击弹出解释视图
 */
@property (nonatomic, strong) UIButton   *popViewBtn;

@property (nonatomic, strong) UIImageView *backgroundImageV;//背景框

@property (nonatomic, strong) UIImageView *uploadImageV;//需要上传的图片

@property (nonatomic, strong) UIButton    *statusBtn;//认证状态标签

@end

@implementation YDAuthenticateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        
        [self y_layoutSubviews];
    }
    return self;
}

- (void)setModel:(YDAuthenticateModel *)model{
    _model = model;
    if (model.image) {
        _uploadImageV.image = model.image;
    }
    else{
        [_uploadImageV yd_setImageWithString:model.imageUrl showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    _titleLabel.text = model.title;
    
    if ([model.title isEqualToString:@"请上传行驶证正本"] || [model.title isEqualToString:@"请上传行驶证副本"]) {
        _popViewBtn.hidden = YES;
    }else{
        _popViewBtn.hidden = NO;
    }
    
    //认证状态("integer,用户认证状态 0未认证 1已认证 2认证中 3 认证失败")
    switch (model.authStatus) {
        case 0:
            _statusBtn.hidden = YES;
            break;
        case 1:
        {
            [_statusBtn setTitle:@"审核成功" forState:0];
            _statusBtn.hidden = NO;
            [_statusBtn setBackgroundImage:[UIImage imageNamed:@"mine_auth_highlight"] forState:0];
            break;}
        case 2:
        {
            [_statusBtn setTitle:@"认证中,请等待系统通知..." forState:0];
            _statusBtn.hidden = NO;
            break;}
        case 3:
        {
            [_statusBtn setTitle:@"审核失败" forState:0];
            _statusBtn.hidden = NO;
            break;}
        default:
            break;
    }
}

#pragma mark - Events
- (void)ac_popButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(authenticateCell:clickedPopViewButton:)]) {
        [self.delegate authenticateCell:self clickedPopViewButton:sender];
    }
}

- (void)y_layoutSubviews{
    [self.contentView sd_addSubviews:@[self.flowerImageV,self.titleLabel,self.popViewBtn,self.backgroundImageV]];
    [_backgroundImageV sd_addSubviews:@[self.uploadImageV,self.statusBtn]];
    
    [_flowerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_flowerImageV.mas_right).offset(5);
        make.centerY.equalTo(_flowerImageV);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(250);
    }];
    
    [_popViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_flowerImageV);
        make.left.equalTo(_titleLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [_backgroundImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(40, 18, 0, 18));
    }];
    
    [_uploadImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backgroundImageV).insets(UIEdgeInsetsMake(1, 1, 1, 1));
    }];
    
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_backgroundImageV);
        make.height.mas_equalTo(kHeight(40));
    }];
    
}

- (UIImageView *)flowerImageV{
    if (!_flowerImageV) {
        _flowerImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_auth_flower"]];
    }
    return _flowerImageV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelTextColor:[UIColor colorWithString:@"#9B9B9B"] fontSize:14];
    }
    return _titleLabel;
}

- (UIImageView *)backgroundImageV{
    if (!_backgroundImageV) {
        _backgroundImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_auth_backImage"]];
        UIButton *addBtn = [YDUIKit buttonWithImage:[UIImage imageNamed:@"mine_auth_add"] selectedImage:[UIImage imageNamed:@"mine_auth_add"] selector:nil target:nil];
        [_backgroundImageV addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_backgroundImageV);
            make.width.height.mas_equalTo(kWidth(42));
        }];
    }
    return _backgroundImageV;
}

- (UIButton *)popViewBtn{
    if (!_popViewBtn) {
        _popViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popViewBtn setImage:@"mine_auth_pop_btn_icon" imageHL:@"mine_auth_pop_btn_icon"];
        [_popViewBtn addTarget:self action:@selector(ac_popButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popViewBtn;
}

- (UIImageView *)uploadImageV{
    if (!_uploadImageV) {
        _uploadImageV = [[UIImageView alloc] init];
        _uploadImageV.contentMode = UIViewContentModeScaleAspectFill;
        _uploadImageV.clipsToBounds = YES;
    }
    return _uploadImageV;
}

- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn = [UIButton new];
        [_statusBtn setBackgroundImage:[UIImage imageNamed:@"mine_auth_normal"] forState:0];
        _statusBtn.hidden = YES;
    }
    return _statusBtn;
}


@end


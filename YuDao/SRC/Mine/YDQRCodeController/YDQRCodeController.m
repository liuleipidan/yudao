//
//  YDQRCodeController.m
//  YuDao
//
//  Created by 汪杰 on 17/1/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDQRCodeController.h"

#define kQRCoedURL [kOriginalURL stringByAppendingString:@"meqrcode"]

@interface YDQRCodeController ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIImageView *headerImageV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *idLabel;

@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) UIImageView *codeImageV;

@end

@implementation YDQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"我的二维码"];
    
    self.view.backgroundColor = [UIColor grayBackgoundColor];
    [self.view addSubview:self.backgroundView];
    
    [_backgroundView sd_addSubviews:@[self.headerImageV,self.nameLabel,self.codeImageV,self.hintLabel,self.idLabel]];
    
    YDUser *user = [YDUserDefault defaultUser].user;
    [_headerImageV yd_setImageWithString:user.ud_face placeholaderImageString:kDefaultAvatarPath showIndicator:NO indicatorStyle:0];
    _nameLabel.text = user.ub_nickname;
    
    _idLabel.text = [NSString stringWithFormat:@"ID：%@",user.ub_id];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@&&&%@",@"http://a.app.qq.com/o/simple.jsp?pkgname=com.ve_link.androids",user.ub_id];
    NSLog(@"urlStr = %@",urlStr);
    //根据URL制作二维码
    self.codeImageV.image = [UIImage erCodeImageByUrlString:urlStr];
    
    [self QR_addMasonry];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)QR_addMasonry{
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(80), kWidth(35), kHeight(128), kWidth(35)));
    }];
    
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView).offset(30);
        make.left.equalTo(_backgroundView).offset(20);
        make.width.height.mas_equalTo(50);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImageV.mas_top);
        make.left.equalTo(_headerImageV.mas_right).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headerImageV.mas_bottom);
        make.left.equalTo(_nameLabel.mas_left);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_codeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backgroundView).offset(-kHeight(67));
        make.left.equalTo(_backgroundView).offset(kWidth(40));
        make.right.equalTo(_backgroundView).offset(-kWidth(46));
        make.height.mas_equalTo(_codeImageV.mas_width);
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backgroundView).offset(-20);
        make.height.mas_equalTo(17);
        make.centerX.equalTo(_backgroundView);
        make.width.mas_lessThanOrEqualTo(250);
    }];
}

#pragma mark - Getters
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.cornerRadius = 8.0f;
        _backgroundView.layer.shadowOffset = CGSizeMake(0, 0);
        _backgroundView.layer.shadowColor = [UIColor shadowColor].CGColor;
        _backgroundView.layer.shadowOpacity = 1;
        
    }
    return _backgroundView;
}

- (UIImageView *)headerImageV{
    if (!_headerImageV) {
        _headerImageV = [[UIImageView alloc] init];
        _headerImageV.layer.cornerRadius = 25.0f;
        _headerImageV.layer.masksToBounds = YES;
    }
    return _headerImageV;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_16]];
    }
    return _nameLabel;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
        _hintLabel.text = @"扫一扫上面的二维码图案，加我为好友";
    }
    return _hintLabel;
}

- (UILabel *)idLabel{
    if (_idLabel == nil) {
        _idLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14]];
    }
    return _idLabel;
}

- (UIImageView *)codeImageV{
    if (!_codeImageV) {
        _codeImageV = [[UIImageView alloc] init];
    }
    return _codeImageV;
}

@end

//
//  YDAboutUsViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/9/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAboutUsViewController.h"
#import "YDWKWebViewController.h"

@interface YDAboutUsViewController ()

@property (nonatomic, strong) UIImageView *iconImageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *webNameLabel;

@property (nonatomic, strong) UILabel *webLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation YDAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self auc_initUI];
    
}

- (void)auc_initUI{
    [self.navigationItem setTitle:@"关于我们"];
    
    self.view.backgroundColor = [UIColor grayBackgoundColor];
    
    [self.view yd_addSubviews:@[self.iconImageV,self.titleLabel,self.versionLabel,self.contentLabel,self.webNameLabel,self.webLabel,self.phoneLabel]];
    
    [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kHeight(50));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(96, 96));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageV.mas_bottom).offset(15);
        make.centerX.equalTo(_iconImageV);
        make.height.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(_iconImageV);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(_versionLabel.mas_bottom).offset(55);
        make.height.mas_lessThanOrEqualTo(150);
    }];
    
    [_webNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel);
        make.top.equalTo(_contentLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_webLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_webNameLabel.mas_right).offset(0);
        make.centerY.equalTo(_webNameLabel);
        make.height.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel);
        make.top.equalTo(_webNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(250);
    }];
}

#pragma mark - Events
- (void)au_webLabelAction:(UIGestureRecognizer *)tap{
    self.webLabel.textColor = [UIColor lightGrayColor];
    self.webLabel.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       self.webLabel.textColor = [UIColor blackColor];
        self.webLabel.userInteractionEnabled = YES;
        YDWKWebViewController *webVC = [[YDWKWebViewController alloc] init];
        webVC.title = @"加载中...";
        [webVC setUrlString:@"http://www.ve-link.com"];
        [self.navigationController pushViewController:webVC animated:YES];
    });
}

#pragma mark - Getters
- (UIImageView *)iconImageV{
    if (!_iconImageV) {
        _iconImageV = [[UIImageView alloc] initWithImage:YDImage(@"YuDaoLogo")];
        _iconImageV.layer.cornerRadius = 18.0f;
        _iconImageV.clipsToBounds = YES;
    }
    return _iconImageV;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:18]];
        _titleLabel.text = @"遇车会友 · 驭车有道";
    }
    return _titleLabel;
}

- (UILabel *)versionLabel{
    if (_versionLabel == nil) {
        _versionLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_14] textAlignment:NSTextAlignmentCenter];
        NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        _versionLabel.text = [NSString stringWithFormat:@"遇道版本 %@",thisVersion];
    }
    return _versionLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
        _contentLabel.numberOfLines = 0;
        [_contentLabel setText:@"遇道是由驭联智能科技发展（上海）有限公司研发，运营的基于汽车的社交娱乐平台，旨在为广大汽车用户提供一个兴趣交友，车辆安全出行，车辆保养服务的全方位服务。" lineSpacing:7];
    }
    return _contentLabel;
}

- (UILabel *)webNameLabel{
    if (!_webNameLabel) {
        _webNameLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
        _webNameLabel.text = @"官方网站：";
    }
    return _webNameLabel;
}

- (UILabel *)webLabel{
    if (!_webLabel) {
        _webLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"www.ve-link.com" attributes:attribtDic];
        //赋值
        _webLabel.attributedText = attribtStr;
        _webLabel.userInteractionEnabled = YES;
        [_webLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(au_webLabelAction:)]];
    }
    return _webLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_14]];
        _phoneLabel.text = @"客服电话：021-52696978";
    }
    return _phoneLabel;
}

@end

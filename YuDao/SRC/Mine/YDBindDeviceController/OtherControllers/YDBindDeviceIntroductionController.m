//
//  YDBindDeviceIntroductionController.m
//  YuDao
//
//  Created by 汪杰 on 2018/4/25.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDBindDeviceIntroductionController.h"
#import "YDBindDeviceController.h"
#import "YDScannerViewController.h"

@interface YDBindDeviceIntroductionController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introducedLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;

@end

@implementation YDBindDeviceIntroductionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"绑定设备"];
    
    [self.view yd_addSubviews:@[self.titleLabel,
                                self.introducedLabel,
                                self.scrollView,
                                self.hintLabel,
                                self.firstButton,
                                self.secondButton]];
    [self bdc_addMasonry];
    [self bdc_addDeviceIntroductionImages];
}

//扫描
- (void)bdc_firstButtonAction:(UIButton *)sender{
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    id previousVC = [self.navigationController findViewController:self previousLevel:1];
    if ([previousVC isKindOfClass:[YDScannerViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        YDScannerViewController *scanner = [YDScannerViewController new];
        scanner.disableMoreButton = YES;
        [self.navigationController pushViewController:scanner animated:YES];
    }
}

//手输
- (void)bdc_secondButtonAction:(UIButton *)sender{
    if (!YDHadLogin) {
        [YDMBPTool showInfoImageWithMessage:@"用户未登录" hideBlock:^{
            [self presentViewController:[YDLoginViewController new] animated:YES completion:nil];
        }];
        return;
    }
    YDBindDeviceController *bindVC = [YDBindDeviceController new];
    bindVC.carInfo = self.carInfo;
    [self.navigationController pushViewController:bindVC animated:YES];
}
//加入介绍图
- (void)bdc_addDeviceIntroductionImages{
    NSArray<NSString *> *images = @[@"scanner_device_veBox",
                                    @"scanner_device_veBox"];
    CGFloat leftSpace = kWidth(49);
    CGFloat rightSpace = leftSpace;
    __block CGFloat x = leftSpace;
    CGFloat y = 20;
    CGFloat height = (SCREEN_WIDTH-60) * 0.83 - y * 2;
    CGFloat width = height;
    CGFloat marginX = 25;
    [images enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = [UIImage imageNamed:obj];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.scrollView addSubview:imageView];
        
        x += (idx * (marginX + width));
        [imageView setFrame:CGRectMake(x, y, width, height)];
        
        if (idx == images.count - 1) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(imageView.frame) + rightSpace, y*2+height);
        }
    }];
}
//添加约束
- (void)bdc_addMasonry{
    
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, 30)];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(kHeight(10));
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(size.width);
    }];
    
    [_introducedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kHeight(20));
        make.centerX.equalTo(self.view);
        make.width.lessThanOrEqualTo(self.titleLabel.mas_width);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introducedLabel.mas_bottom).offset(kHeight(20));
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(self.scrollView.mas_width).multipliedBy(0.83);
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.scrollView.mas_bottom).offset(kHeight(20));
        make.height.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-20);
    }];
    
    [_secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-kHeight(20));
        make.height.mas_equalTo(44);
    }];
    
    [_firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.secondButton.mas_top).offset(-kHeight(10));
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YDUIKit labelWithTextColor:YDBaseColor text:@"绑定VE-BOX，将您的爱车装进手机里" fontSize:16 textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}
- (UILabel *)introducedLabel{
    if (!_introducedLabel) {
        _introducedLabel = [UILabel labelByTextColor:[UIColor grayTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter];
        [_introducedLabel setText:@"初次安装VE-BOX/VE-AIR设备的用户，需将设备与您的帐号进行绑定。" lineSpacing:6];
        _introducedLabel.numberOfLines = 2;
    }
    return _introducedLabel;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor shadowColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [YDUIKit labelWithTextColor:[UIColor grayTextColor] text:@"扫描VE-BOX盒子上的二维码，即可绑定" fontSize:12 textAlignment:NSTextAlignmentCenter];
    }
    return _hintLabel;
}

- (UIButton *)firstButton{
    if (!_firstButton) {
        _firstButton = [UIButton new];
        [_firstButton setBackgroundImage:[UIImage imageNamed:@"mine_auth_button_highlight"] forState:0];
        [_firstButton setTitle:@"立即扫描" forState:0];
        [_firstButton addTarget:self action:@selector(bdc_firstButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}
- (UIButton *)secondButton{
    if (!_secondButton) {
        _secondButton = [UIButton new];
        [_secondButton setBackgroundImage:[UIImage imageNamed:@"mine_auth_button_normal"] forState:0];
        [_secondButton setTitle:@"手动输入" forState:0];
        [_secondButton setTitleColor:YDBaseColor forState:0];
        [_secondButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_secondButton addTarget:self action:@selector(bdc_secondButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondButton;
}

@end

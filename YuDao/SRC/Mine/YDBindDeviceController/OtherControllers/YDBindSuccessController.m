//
//  YDBindSuccessController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBindSuccessController.h"
#import "YDGarageViewController.h"
#import "YDHomePageController.h"

@interface YDBindSuccessController ()

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation YDBindSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"成功绑定"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    
    _imgV = [[UIImageView alloc] initWithImage:YDImage(@"mine_bind_success")];
    _titleLabel = [YDUIKit labelWithTextColor:YDBaseColor text:@"恭喜\n您的设备已成功绑定" fontSize:24 textAlignment:NSTextAlignmentCenter];
    _titleLabel.numberOfLines = 2;
    _subTitleLabel = [YDUIKit labelWithTextColor:[UIColor grayTextColor] text:@"现在您可以使用“测一测”功能，同时体验LV5会员服务。" fontSize:12 textAlignment:NSTextAlignmentCenter];
    
    [self.view yd_addSubviews:@[_imgV,_titleLabel,_subTitleLabel]];
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(73);
        make.width.height.mas_equalTo(60);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_imgV.mas_bottom).offset(16);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_greaterThanOrEqualTo(70);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_titleLabel.mas_bottom).offset(16);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(21);
    }];
    
}

- (void)rightItemAction:(UIBarButtonItem *)item{
    NSArray *controllers = _presentingVC.navigationController.viewControllers;
    for (UIViewController *rootVC in controllers) {
        if ([rootVC isKindOfClass:[YDGarageViewController class]]) {
            [_presentingVC.navigationController popToViewController:rootVC animated:YES];
        }
        if ([rootVC isKindOfClass:[YDHomePageController class]]) {
            [_presentingVC.navigationController popToViewController:rootVC animated:YES];
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        _presentingVC = nil;
    }];
}

@end

//
//  YDActivityJoinSccessController.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDActivityJoinSccessController.h"
#import "YDActivityViewController.h"

@interface YDActivityJoinSccessController ()

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation YDActivityJoinSccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"报名成功"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    
    _imgV = [[UIImageView alloc] initWithImage:YDImage(@"mine_bind_success")];
    _titleLabel = [YDUIKit labelWithTextColor:YDBaseColor text:@"恭喜，您已报名成功" fontSize:24 textAlignment:NSTextAlignmentCenter];
    _titleLabel.numberOfLines = 2;
    _subTitleLabel = [YDUIKit labelWithTextColor:[UIColor grayTextColor] text:@"本次活动您已经获得了300积分奖励" fontSize:12 textAlignment:NSTextAlignmentCenter];
    _tipLabel = [YDUIKit labelWithTextColor:[UIColor grayTextColor] text:@"请保持手机畅通，将会有工作人员与您联系" fontSize:14 textAlignment:NSTextAlignmentCenter];
    [self.view yd_addSubviews:@[_imgV,_titleLabel,_subTitleLabel,_tipLabel]];
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(73);
        make.width.height.mas_equalTo(60);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_imgV.mas_bottom).offset(16);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_greaterThanOrEqualTo(35);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_titleLabel.mas_bottom).offset(16);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(21);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(21);
    }];
    if (!YDHadLogin) {
        _subTitleLabel.text = @"";
        [_tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(_subTitleLabel.mas_bottom).offset(16);
        }];
    }else{
        [_tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subTitleLabel.mas_bottom).offset(0);
        }];
    }
    
}

- (void)rightItemAction:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end

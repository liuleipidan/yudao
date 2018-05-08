//
//  WJGoSettingView.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "WJGoSettingView.h"
//屏幕宽
#define kSCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
//屏幕高
#define kSCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation WJGoSettingView
{
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kSCREEN_HEIGHT-20)/2, kSCREEN_WIDTH, 20)];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"相机无法访问";
    titleLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:titleLabel];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setBackgroundColor:[UIColor greenColor]];
    [settingBtn setTitle:@"设置" forState:0];
    [settingBtn.layer setCornerRadius:5.0];
    settingBtn.frame = CGRectMake((kSCREEN_WIDTH-60)/2, CGRectGetMaxY(titleLabel.frame)+5, 60, 40);
    [settingBtn addTarget:self action:@selector(clickSettingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:settingBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:0];
    cancelBtn.frame = CGRectMake(kSCREEN_HEIGHT-100, 100, 60, 40);
    [cancelBtn addTarget:self action:@selector(clickCancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelBtn];
    
}

- (void)clickCancelBtnAction:(UIButton *)sender{
    if (self.clickCancelBlock) {
        self.clickCancelBlock();
    }
}

- (void)clickSettingBtnAction:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"UIApplicationOpenSettingsURLString"]];
    
}

@end

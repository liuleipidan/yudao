//
//  YDTestOBDStatusView.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/9.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestOBDStatusView.h"

@interface YDTestOBDStatusView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation YDTestOBDStatusView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8.0f;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowColor = [UIColor shadowColor].CGColor;
        self.layer.shadowOpacity = 1;
        
        [self yd_addSubviews:@[self.imageView,self.statusLabel]];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(25, 26));
        }];
        
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.imageView.mas_right).offset(10);
            make.height.mas_equalTo(22);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        
    }
    return self;
}

- (void)showByOBDStatus:(BOOL)isOpen{
    if (isOpen) {
        self.imageView.image = [UIImage imageNamed:@"test_boxstatus_open"];
        self.statusLabel.text = @"VE-BOX正在工作中";
    }
    else{
        self.imageView.image = [UIImage imageNamed:@"test_boxstatus_close"];
        self.statusLabel.text = @"VE-BOX已关闭";
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismissByAnimation:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        }];
    }
    else{
        self.alpha = 0;
    }
}

#pragma mark - Getters
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)statusLabel{
    if (_statusLabel == nil) {
        _statusLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont pingFangSC_MediumFont:16]];
    }
    return _statusLabel;
}

@end

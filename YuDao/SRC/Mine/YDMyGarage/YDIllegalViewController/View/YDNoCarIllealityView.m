
//
//  YDNoCarIllealityView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDNoCarIllealityView.h"

@interface YDNoCarIllealityView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YDNoCarIllealityView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self nci_initSubviews];
        [self nci_addMasonry];
        
    }
    return self;
}

#pragma mark - Private Methods
- (void)nci_initSubviews{
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_bind_success"]];
    
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_18] textAlignment:NSTextAlignmentCenter];
    _titleLabel.text = @"您目前没有违章记录";
    
    [self yd_addSubviews:@[_imageView,_titleLabel]];
    
}

- (void)nci_addMasonry{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(45);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(32);
    }];
}

@end

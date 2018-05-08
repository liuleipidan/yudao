//
//  YDPCBCollectionViewCell.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPCBCollectionViewCell.h"

@interface YDPCBCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YDPCBCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self pcb_initSubviews];
        [self pcb_addMasonry];
    }
    return self;
}

- (void)setItem:(YDCarBrand *)item{
    _item = item;
    if (item.logoPath) {
        [_imageView setImage:[UIImage imageNamed:item.logoPath]];
    }
    else{
        [_imageView yd_setImageFadeinWithString:item.logo];
    }
    _titleLabel.text = item.vb_name;
}

#pragma mark - Private Methods
- (void)pcb_initSubviews{
    _imageView = [UIImageView new];
    _imageView.layer.cornerRadius = 8.0f;
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_12] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    _titleLabel.text = @"英菲尼迪";
    
    [self.contentView yd_addSubviews:@[_imageView,_titleLabel]];
}

- (void)pcb_addMasonry{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(45.0f);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(3);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(17);
    }];
}

@end

//
//  YDTestTitleView.m
//  YuDao
//
//  Created by 汪杰 on 2018/3/23.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestTitleView.h"

@interface YDTestTitleView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YDTestTitleView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [UILabel labelByTextColor:[UIColor whiteColor] font:[UIFont font_18]];
        
        _imageView  = [[UIImageView alloc] initWithImage:YDImage(@"test_changecar_icon")];
        
        [self yd_addSubviews:@[_titleLabel,_imageView]];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tt_tapSelfAction:)]];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    CGFloat width = [title yd_stringWidthBySize:CGSizeMake(CGFLOAT_MAX, 25) font:[UIFont font_18]];
    _titleLabel.text = title;
    _titleLabel.frame = CGRectMake(0, 0, width, 25);
    
    if ([[YDCarHelper sharedHelper] hadBoundDeviceCars].count > 1) {
        _imageView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, (25-8)/2.0, 14, 8);
        
        self.frame = CGRectMake(0, 0, CGRectGetMaxX(_imageView.frame), 25);
    }
    else{
        _imageView.frame = CGRectZero;
        
        self.frame = CGRectMake(0, 0, CGRectGetMaxX(_titleLabel.frame), 25);
        
        self.userInteractionEnabled = NO;
    }
    
}

- (void)tt_tapSelfAction:(UITapGestureRecognizer *)tap{
    if (_TTTapChangeCarBlock) {
        _TTTapChangeCarBlock();
    }
}

@end

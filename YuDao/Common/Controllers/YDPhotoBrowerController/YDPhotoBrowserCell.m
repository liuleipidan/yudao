//
//  YDPhotoBrowserCell.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPhotoBrowserCell.h"

@interface YDPhotoBrowserCell()

@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation YDPhotoBrowserCell

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    
    _image = image;
    _imgV.image = image;
}

- (void)initSubviews{
    _imgV = [UIImageView new];
    _imgV.backgroundColor = [UIColor blackColor];
    _imgV.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_imgV];
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 2.5, 0, 2.5));
    }];
    
}

@end

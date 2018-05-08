//
//  YDZoomingScrollView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDZoomingScrollView.h"

@interface YDZoomingScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation YDZoomingScrollView

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)initSubviews{
    self.backgroundColor = [UIColor blackColor];
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    _imgV = [[UIImageView alloc] init];
    [self addSubview:_imgV];
    
}

- (void)displayImage{
    if (_image) {
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.contentSize = CGSizeZero;
        
        _imgV.image = _image;
        
    }
}

@end

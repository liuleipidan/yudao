//
//  YDScrollGradientView.m
//  YuDao
//
//  Created by 汪杰 on 2017/6/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDScrollGradientView.h"

#define kDefaultSGFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

@interface YDScrollGradientView()

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation YDScrollGradientView
{
    CGRect _initFrame;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _stretchAnimation = YES;
        _initFrame = frame;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self configBgImageView];
    }
    return self;
}

- (instancetype)init{
    if(self = [super init]){
        _stretchAnimation = YES;
        [self configBgImageView];
    }
    return self;
}

- (void)configBgImageView{
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:_bgImageView];
}

- (void)setBgImage:(UIImage *)bgImage{
    _bgImageView.image = bgImage;
}

- (void)setBgImageUrl:(NSString *)bgImageUrl{
    [_bgImageView yd_setImageFadeinWithString:bgImageUrl];
}

- (void)yd_parallaxViewWithOffsetY:(CGFloat )offsetY{
    if (offsetY > 0) {
        CGRect frame = _bgImageView.frame;
        frame.origin.y = MAX(offsetY/2, 0);
        _bgImageView.frame = frame;
        
    }else{
        CGFloat delta = 0.f;
        CGRect rect = _initFrame;
        delta = fabs(MIN(0.f, offsetY));
        rect.origin.y -= delta;
        
        rect.size.height += delta;
        self.frame = rect;
        
    }
}

@end

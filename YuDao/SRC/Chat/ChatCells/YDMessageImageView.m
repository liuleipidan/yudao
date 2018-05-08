//
//  YDMessageImageView.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMessageImageView.h"

@interface YDMessageImageView()

@property (nonatomic, assign) CAShapeLayer *maskLayer;

@property (nonatomic, assign) CALayer *contentLayer;

@property (nonatomic, strong) UIActivityIndicatorView *indeicatorView;

@end

@implementation YDMessageImageView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.contentsCenter = CGRectMake(0.5, 0.6, 0.1, 0.1);
        //设置自动拉伸的效果且不变形
        maskLayer.contentsScale = [UIScreen mainScreen].scale;
        CALayer *contentLayer = [[CALayer alloc] init];
        [contentLayer setMask:maskLayer];
        [self.layer addSublayer:contentLayer];
        
        self.maskLayer = maskLayer;
        self.contentLayer = contentLayer;
        [self addSubview:self.indeicatorView];
        [self.indeicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.maskLayer setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.contentLayer setFrame:CGRectMake(0, 0, self.width, self.height)];
}

- (void)setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    UIImage *image = [UIImage imageNamed:imagePath];
    [self.contentLayer setContents:(id)(image.CGImage)];
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    YDWeakSelf(self);
    [self yd_setImageFadeinWithString:nil];
    UIImage *placeholder = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    if (placeholder) {
        [self.contentLayer setContents:(id)(placeholder.CGImage)];
    }else{
        [self.indeicatorView startAnimating];
        [self.contentLayer setContents:(id)([UIImage imageWithColor:[UIColor lightGrayColor]].CGImage)];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (finished) {
                [self.indeicatorView stopAnimating];
            }
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.contentLayer setContents:(id)(image.CGImage)];
                });
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES completion:^{
                    
                }];
            }
        }];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    [self.maskLayer setContents:(id)backgroundImage.CGImage];
}


- (UIActivityIndicatorView *)indeicatorView{
    if (!_indeicatorView) {
        _indeicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indeicatorView;
}

@end

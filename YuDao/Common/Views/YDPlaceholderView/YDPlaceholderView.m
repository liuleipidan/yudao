//
//  YDPlaceholderView.m
//  YuDao
//
//  Created by 汪杰 on 2017/11/13.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPlaceholderView.h"

#define kPlaceholderViewReloadButtonTitle  @"加载失败，点击重试"
#define kPlaceholderViewNoDataTitleDefault @"暂无此类数据"

@implementation YDPlaceholderView
{
    UIButton *_reloadBtn;
    UILabel  *_noDataLabel;
    UIImageView *_noDataImageView;
}
- (instancetype)initWithFrame:(CGRect)frame
                         type:(YDPlaceholderViewType )type
         reloadBtnActionBlock:(void (^)(void))reloadBtnActionBlock{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _reloadBtnActionBlock = reloadBtnActionBlock;
        [self pv_setupSubviews];
        [self setYOffset:-32];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                         type:(YDPlaceholderViewType )type
                     delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _delegate = delegate;
        [self pv_setupSubviews];
        [self setYOffset:-32];
    }
    return self;
}

#pragma mark - Public Methods
- (void)showInView:(UIView *)view{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YDPlaceholderView class]]) {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
    
    [view addSubview:self];
}

- (void)setReloadButtonTitle:(NSString *)reloadButtonTitle{
    [_reloadBtn setTitle:reloadButtonTitle forState:0];
}

- (void)setNoDataImage:(UIImage *)noDataImage{
    [_noDataImageView setImage:noDataImage];
}

- (void)setNoDataTitle:(NSString *)noDataTitle{
    [_noDataLabel setText:noDataTitle];
}

- (void)setYOffset:(CGFloat)yOffset{
    _yOffset = yOffset;
    for (UIView *subview in self.subviews) {
        subview.y += yOffset;
    }
    [self layoutIfNeeded];
}

- (void)setXOffset:(CGFloat)xOffset{
    _xOffset = xOffset;
    for (UIView *subview in self.subviews) {
        subview.x += xOffset;
    }
    [self layoutIfNeeded];
}

#pragma mark - Events
- (void)pv_reloadButtonAction:(UIButton *)sender{
    if (self.reloadBtnActionBlock) {
        self.reloadBtnActionBlock();
    }
    else if (self.delegate && [self.delegate respondsToSelector:@selector(placeholderView:reloadButtonDidClicked:)]){
        [self.delegate placeholderView:self reloadButtonDidClicked:sender];
    }
    [self removeAllSubViews];
    [self removeFromSuperview];
}

- (void)pv_setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    if (_type == YDPlaceholderViewTypeFailure) {
        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadBtn setTitle:kPlaceholderViewReloadButtonTitle forState:0];
        [reloadBtn setTitleColor:[UIColor grayTextColor1] forState:0];
        reloadBtn.frame = CGRectMake(0, (self.width - 62)/2.0, self.width, 62);
        [reloadBtn addTarget:self action:@selector(pv_reloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _reloadBtn = reloadBtn;
        [self addSubview:reloadBtn];
    }else{
        UIImageView *imageV = [[UIImageView alloc] initWithImage:YDImage(@"placeholderView_icon_nodata")];
        imageV.frame = CGRectMake((self.width - 115)/2.0, (self.height - 110)/2.0, 115, 110);
        _noDataImageView = imageV;
        
        UILabel *label = [UILabel labelByTextColor:[UIColor grayTextColor1] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter];
        label.text = kPlaceholderViewNoDataTitleDefault;
        label.frame = CGRectMake((self.width - 100)/2.0, CGRectGetMaxY(imageV.frame) + 10, 100, 20);
        _noDataLabel = label;
        [self yd_addSubviews:@[imageV,label]];
    }
}

@end

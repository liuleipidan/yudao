//
//  YDAvatarBrowser.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/28.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAvatarBrowser.h"
#import "YDCoustomTapGestureRecognizer.h"

@interface YDAvatarBrowser()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) YDCoustomTapGestureRecognizer *singleTap;

@property (nonatomic, strong) YDCoustomTapGestureRecognizer *doubleTap;

@property (nonatomic, strong) UILongPressGestureRecognizer *longTap;

@end

@implementation YDAvatarBrowser

- (id)init{
    if (self = [super init]) {
        [self ab_initial];
    }
    return self;
}

- (void)ab_initial{
    _disableEditButton = NO;
    _disableDoubleTap = NO;
    _disableLongpress = NO;
    _frameAnimate = NO;
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor blackColor];
    
    _singleTap = [[YDCoustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(ab_singleTapBackgroundView:)];
    _singleTap.numberOfTapsRequired = 1;
    
    _doubleTap = [[YDCoustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(ab_doubleTapBackgroundView:)];
    _doubleTap.numberOfTapsRequired = 2;
    
    //暂时关闭双击，因为需要单击时需要延时
    [_singleTap requireGestureRecognizerToFail:_doubleTap];
    
    _longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ab_longTapBackgroundView:)];
    
    [self addGestureRecognizer:_singleTap];
    [self addGestureRecognizer:_doubleTap];
    [self addGestureRecognizer:_longTap];
}

- (void)showByImageView:(UIImageView *)imageView inView:(UIView *)view{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    self.backgroundColor = [UIColor blackColor];
    _oldFrame = [imageView convertRect:imageView.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self.photoImageView setImage:imageView.image];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.bottomButton];
    [view addSubview:self];
    self.alpha = 0;
    
    CGRect photoImageFrame = [self ab_photoImageViewFrame];
    [self ab_setMaxAndMinZoomScalesByRect:photoImageFrame];
    
    if (self.frameAnimate) {
        self.photoImageView.frame = _oldFrame;
    }
    else{
        self.photoImageView.frame = photoImageFrame;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.photoImageView.frame = photoImageFrame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss{
    
    if (self.frameAnimate) {
        //回到初始尺寸
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [UIView animateWithDuration:0.25 animations:^{
            [self.photoImageView setFrame:self.oldFrame];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    
}

#pragma mark - Setters
- (void)setDisableEditButton:(BOOL)disableEditButton{
    _disableEditButton = disableEditButton;
    self.bottomButton.hidden = disableEditButton;
}

- (void)setDisableDoubleTap:(BOOL)disableDoubleTap{
    _disableDoubleTap = disableDoubleTap;
    if (disableDoubleTap) {
        [self.doubleTap removeTarget:nil action:nil];
    }
    else{
        [self.doubleTap addTarget:self action:@selector(ab_doubleTapBackgroundView:)];
    }
}

- (void)setDisableLongpress:(BOOL)disableLongpress{
    _disableLongpress = disableLongpress;
    if (disableLongpress) {
        [self.longTap removeTarget:nil action:nil];
    }
    else{
        [self.longTap addTarget:self action:@selector(ab_longTapBackgroundView:)];
    }
}

#pragma mark - Events
//单击
- (void)ab_singleTapBackgroundView:(UIGestureRecognizer *)tap{
    [self dismiss];
}

//双击
- (void)ab_doubleTapBackgroundView:(UIGestureRecognizer *)tap{
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else {
        CGPoint point = [tap locationInView:tap.view];
        CGFloat touchX = point.x;
        CGFloat touchY = point.y;
        touchX *= 1/self.scrollView.zoomScale;
        touchY *= 1/self.scrollView.zoomScale;
        touchX += self.scrollView.contentOffset.x;
        touchY += self.scrollView.contentOffset.y;
        
        CGRect zoomRect = [self ab_zoomRectForScale:self.scrollView.maximumZoomScale withCenter:CGPointMake(touchX, touchY)];
        [self.scrollView zoomToRect:zoomRect animated:YES];
        
    }
}

//长按
- (void)ab_longTapBackgroundView:(UIGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存图片"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
            if (index == 1) {
                UIImageWriteToSavedPhotosAlbum(self.photoImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
    }
}

//底部按钮action
- (void)ab_bottomButtonAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(avatarBrowser:didClickedBottomButton:)]) {
        [self.delegate avatarBrowser:self didClickedBottomButton:sender];
    }
}

//保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = error == NULL ? @"保存图片成功" : @"保存图片失败" ;
    [YDMBPTool showText:msg];
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.photoImageView.center = [self ab_centerOfScrollViewContent:scrollView];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    self.scrollView.scrollEnabled = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    self.scrollView.userInteractionEnabled = YES;
}



#pragma mark - Private Methods
//重置scrollView的放大和缩放比例
- (void)ab_resetZoomScale
{
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
}
/**
 *  根据图片和屏幕比例关系,调整最大和最小伸缩比例
 */
- (void)ab_setMaxAndMinZoomScalesByRect:(CGRect)frame
{
    // self.photoImageView的初始位置
    UIImage *image = self.photoImageView.image;
    if (image == nil || image.size.height == 0) {
        return;
    }
    if (frame.size.height > self.height) {
        self.scrollView.scrollEnabled = YES;
    }
    else {
        self.scrollView.scrollEnabled = NO;
    }
    self.scrollView.maximumZoomScale = MAX(self.height / frame.size.height, 3.0);
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = CGSizeMake(frame.size.width, MAX(frame.size.width, self.height));
}

//图片展示后的frame
- (CGRect)ab_photoImageViewFrame{
    UIImage *image = self.photoImageView.image;
    CGFloat imageWidthHeightRatio = image.size.width / image.size.height;
    CGFloat height = self.width / imageWidthHeightRatio;
    CGFloat y = 0;
    if ( height < self.height) {
        y = (self.height - height) * 0.5;
    }
    return CGRectMake(0, y, self.width, height);
}

//重新计算图片中心位置
- (CGPoint)ab_centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

//双击放大的rect
- (CGRect)ab_zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGFloat height = self.frame.size.height / scale;
    CGFloat width  = self.frame.size.width / scale;
    CGFloat x = center.x - width * 0.5;
    CGFloat y = center.y - height * 0.5;
    return CGRectMake(x, y, width, height);
}

#pragma mark - Getter
- (UIImageView *)photoImageView{
    if (_photoImageView == nil) {
        _photoImageView = [UIImageView new];
        _photoImageView.backgroundColor = [UIColor whiteColor];
    }
    return _photoImageView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [_scrollView setMinimumZoomScale:1];
        [_scrollView setMaximumZoomScale:3];
        [_scrollView setZoomScale:0.5];
        
        _scrollView.delaysContentTouches = NO;
        
        [_scrollView addSubview:self.photoImageView];
    }
    return _scrollView;
}

- (UIButton *)bottomButton{
    if (_bottomButton == nil) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomButton setTitle:@"修改" forState:0];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:0];
        _bottomButton.frame = CGRectMake(0, self.height - 64, self.width, 64);
        [_bottomButton addTarget:self action:@selector(ab_bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

@end

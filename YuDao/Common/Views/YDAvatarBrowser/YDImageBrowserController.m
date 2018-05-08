//
//  YDImageBrowserController.m
//  YuDao
//
//  Created by 汪杰 on 2017/12/29.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDImageBrowserController.h"
#import "YDCoustomTapGestureRecognizer.h"
#import "YDImagePickerTool.h"

@interface YDImageBrowserController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) YDImagePickerTool *imagePickerTool;

@end

@implementation YDImageBrowserController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ibc_initial];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowserControllerOriginalImageV:)]) {
        UIImageView *originalImageV = [self.delegate imageBrowserControllerOriginalImageV:self];
        self.photoImageView.image = originalImageV.image;
        self.oldFrame = [originalImageV convertRect:originalImageV.frame toView:self.view];
        
        [self ab_setMaxAndMinZoomScales];
    }
    
}
- (void)ibc_initial{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.scrollView addSubview:self.photoImageView];
    
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.bottomButton];
    
    YDCoustomTapGestureRecognizer *singleTap = [[YDCoustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(ab_singleTapBackgroundView:)];
    singleTap.numberOfTapsRequired = 1;
    
    YDCoustomTapGestureRecognizer *doubleTap = [[YDCoustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(ab_doubleTapBackgroundView:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self.view addGestureRecognizer:singleTap];
    [self.view addGestureRecognizer:doubleTap];
}

#pragma mark - Events
- (void)ab_singleTapBackgroundView:(UIGestureRecognizer *)tap{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowserController:imageIsChanged:)]) {
        [self.delegate imageBrowserController:self imageIsChanged:YES];
    }
}

- (void)ab_doubleTapBackgroundView:(UIGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:tap.view];
    if (point.y < self.photoImageView.y ||point.y > CGRectGetMaxY(self.photoImageView.frame)) {
        return;
    }
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

- (void)ab_bottomButtonAction:(UIButton *)sender{
    
    YDWeakSelf(self);
    [self.imagePickerTool showActionSheet:^(UIImage *image, NSURL *url) {
        weakself.photoImageView.image = image;
//        [YDNetworking uploadImage:image url:kUploadUserHeaderImageURL success:^(NSString *imageUrl) {
//            YDUser *user = [YDUserDefault defaultUser].user;
//            user.ud_face = YDNoNilString(imageUrl);
//            [YDUserDefault defaultUser].user = user;
//            
//        } failure:^{
//            [YDMBPTool showBriefAlert:@"修改头像失败" time:1.5];
//        }];
    }];
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
- (void)ab_resetZoomScale
{
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
}
/**
 *  根据图片和屏幕比例关系,调整最大和最小伸缩比例
 */
- (void)ab_setMaxAndMinZoomScales
{
    // self.photoImageView的初始位置
    UIImage *image = self.photoImageView.image;
    if (image == nil || image.size.height==0) {
        return;
    }
    CGFloat imageWidthHeightRatio = image.size.width / image.size.height;
    self.photoImageView.width = self.view.width;
    self.photoImageView.height = self.view.width / imageWidthHeightRatio;
    self.photoImageView.x = 0;
    if (self.photoImageView.height > self.view.height) {
        self.photoImageView.y = 0;
        self.scrollView.scrollEnabled = YES;
    } else {
        self.photoImageView.y = (self.view.height - self.photoImageView.height ) * 0.5;
        self.scrollView.scrollEnabled = NO;
    }
    self.scrollView.maximumZoomScale = MAX(self.view.height / self.photoImageView.height, 3.0);
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = CGSizeMake(self.photoImageView.width, MAX(self.photoImageView.width, self.view.height));
}
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

- (CGRect)ab_zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGFloat height = self.view.frame.size.height / scale;
    CGFloat width  = self.view.frame.size.width / scale;
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
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        
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
        [_bottomButton setTitleColor:[UIColor greenColor] forState:0];
        _bottomButton.frame = CGRectMake(0, self.view.height - 64, self.view.width, 64);
        [_bottomButton addTarget:self action:@selector(ab_bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (YDImagePickerTool *)imagePickerTool{
    if (_imagePickerTool == nil) {
        _imagePickerTool = [[YDImagePickerTool alloc] initWithPresentingViewController:self];
    }
    return _imagePickerTool;
}

@end

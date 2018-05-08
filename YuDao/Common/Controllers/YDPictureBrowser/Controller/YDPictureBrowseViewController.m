//
//  YDPictureFirstVC.m
//  YDCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "YDPictureBrowseViewController.h"
#import "YDPictureBrowserCell.h"
#import "YDPictureBrowseSouceModel.h"

@interface YDPictureBrowseViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, YDPictureBrowserCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGPoint transitionImgViewCenter;
@property (nonatomic, strong) UIImageView         *imgView;

@end

@implementation YDPictureBrowseViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] yd_setStatusBarHidden:YES];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] yd_setStatusBarHidden:NO];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    
    //指定对应图片
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.animatedTransition.transitionParameter.transitionImgIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    //隐藏状态栏
    [self prefersStatusBarHidden];
    
    //添加滑动手势
    UIPanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    
}

#pragma mark - Setters
- (void)setDataSouceArray:(NSArray<YDPictureBrowseSouceModel *> *)dataSouceArray{
    _dataSouceArray = dataSouceArray;
    
}

#pragma mark - Getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 0;
        // 布局方式改为从上至下，默认从左到右
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // Section Inset就是某个section中cell的边界范围
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 每行内部cell item的间距
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH + kBrowseSpace, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundView = nil;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[YDPictureBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([YDPictureBrowserCell class])];
    }
    return _collectionView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSouceArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(self.view.frame.size.width + kBrowseSpace, self.view.frame.size.height);
    
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YDPictureBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YDPictureBrowserCell class]) forIndexPath:indexPath];
    [cell showWithModel:self.dataSouceArray[indexPath.item]];
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    
    return cell;
}
#pragma mark - System Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = _collectionView.contentOffset.x;
    NSInteger cellIndex = offset/(SCREEN_WIDTH + kBrowseSpace);
    [self setupBaseViewControllerProperty:cellIndex];
}

#pragma mark - Custom Delegate
- (void)imageViewClick:(NSInteger)cellIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Event
- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    CGFloat scale = 1 - (translation.y / SCREEN_HEIGHT);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            
            [self setupBaseViewControllerProperty:self.animatedTransition.transitionParameter.transitionImgIndex];
            self.collectionView.hidden = YES;
            self.imgView.hidden = NO;
            
            self.animatedTransition.transitionParameter.gestureRecognizer = gestureRecognizer;
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            _imgView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
            _imgView.transform = CGAffineTransformMakeScale(scale, scale);
            
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            if (scale > 0.95f) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.imgView.center = self.transitionImgViewCenter;
                    self.imgView.transform = CGAffineTransformMakeScale(1, 1);
                    
                } completion:^(BOOL finished) {
                    self.imgView.transform = CGAffineTransformIdentity;
                }];
                
                self.collectionView.hidden = NO;
                self.imgView.hidden = YES;
            }else{
            }
            self.animatedTransition.transitionParameter.transitionImage = _imgView.image;
            self.animatedTransition.transitionParameter.currentPanGestImgFrame = _imgView.frame;
            
            self.animatedTransition.transitionParameter.gestureRecognizer = nil;
        }
    }
}

#pragma mark - Private Method
- (void)setupBaseViewControllerProperty:(NSInteger)cellIndex{
    
    YDPictureBrowserCell *cell = (YDPictureBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0]];
    
    self.animatedTransition.transitionParameter.transitionImage = cell.pictureImageScrollView.zoomImageView.image;
    self.animatedTransition.transitionParameter.transitionImgIndex = cellIndex;
    
    self.imgView.frame = cell.pictureImageScrollView.zoomImageView.frame;
    self.imgView.image = cell.pictureImageScrollView.zoomImageView.image;
    self.imgView.hidden = YES;
    self.transitionImgViewCenter = _imgView.center;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

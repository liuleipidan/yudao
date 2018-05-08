//
//  YDPublishDynamicImagesView.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/7.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPublishDynamicImagesView.h"
#import "YDPDImageCell.h"

@interface YDPublishDynamicImagesView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger imagesCount;

@end

@implementation YDPublishDynamicImagesView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

- (void)setItem:(YDPublishDynamicModel *)item{
    _item = item;
    if (!item.isVideo && item.images.count != 9) {
        self.imagesCount = item.images.count + 1;
    }
    else{
        self.imagesCount = item.images.count;
    }
    [self.collectionView reloadData];
}

#pragma mark - YDPublishDynamicCellDelegate
- (void)clickedDelete:(NSInteger)index{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedDelete:)]) {
        [_delegate clickedDelete:index];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesCount;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.item.images.count) {
        YDPDImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDPDImageCell" forIndexPath:indexPath];
        [cell setImage:self.item.images[indexPath.row]];
        [cell setDelegate:self];
        [cell setIsVideo:self.item.isVideo];
        [cell setImageIndex:indexPath.row];
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundView = ({
        UIView *view = [UIView new];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_pd_addIcon"]];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(view);
            make.top.equalTo(view).offset(10);
            make.right.equalTo(view).offset(-10);
        }];
        view;
    });
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kPDImagesRowHeight, kPDImagesRowHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.item.imagesRowSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.item.imagesColSpace;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id cell = [collectionView cellForItemAtIndexPath:indexPath];
    BOOL isAdd = ![cell isKindOfClass:[YDPDImageCell class]];
    
    if (_item.isVideo && _delegate && [_delegate respondsToSelector:@selector(clickedVideo:)]) {
        [_delegate clickedVideo:self.item.videoLocalURL];
    }
    else if (_delegate && [_delegate respondsToSelector:@selector(clickedAdd)] && isAdd){
        [_delegate clickedAdd];
    }
    else if (_delegate && [_delegate respondsToSelector:@selector(clickedImage:)] && !isAdd){
        YDPDImageCell *pdCell = cell;
        [_delegate clickedImage:pdCell.imageIndex];
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[YDPDImageCell class] forCellWithReuseIdentifier:@"YDPDImageCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

@end

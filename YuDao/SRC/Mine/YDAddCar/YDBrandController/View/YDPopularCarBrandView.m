//
//  YDPopularCarBrandView.m
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDPopularCarBrandView.h"

@interface YDPopularCarBrandView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YDPopularCarBrandView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor tableViewSectionHeaderViewBackgoundColor];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)setData:(NSArray<YDCarBrand *> *)data{
    if (data.count == 0) {
        return;
    }
    _data = data;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YDPCBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDPCBCollectionViewCell" forIndexPath:indexPath];
    YDCarBrand *item = [self.data objectAtIndex:indexPath.row];
    [cell setItem:item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor tableViewSectionHeaderViewBackgoundColor];
    UILabel *label = [UILabel labelByTextColor:[UIColor blackTextColor] font:[UIFont font_12] textAlignment:0 backgroundColor:[UIColor clearColor]];
    label.text = @"热门品牌";
    label.frame = CGRectMake(10, 0, SCREEN_WIDTH, 20);
    [headerView addSubview:label];
    
    return headerView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(popularCarBrandView:didSelectedItem:)]) {
         YDCarBrand *item = [self.data objectAtIndex:indexPath.row];
        [self.delegate popularCarBrandView:self didSelectedItem:item];
    }
}
//item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/5.0, (collectionView.height - 20)/2);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}
//组眉大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 20);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 0, 0, 0);
}

#pragma mark - Getter
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[YDPCBCollectionViewCell class] forCellWithReuseIdentifier:@"YDPCBCollectionViewCell"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

@end

//
//  YDPhotoBrowerController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDPhotoBrowerController+Delegate.h"

@implementation YDPhotoBrowerController (Delegate)

#pragma mark  - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _data.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YDPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDPhotoBrowserCell" forIndexPath:indexPath];
    cell.image = [_data objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark  - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.needRefreshBlock) {
        self.needRefreshBlock(_data);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}

@end

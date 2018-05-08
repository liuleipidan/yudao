//
//  YDMoreKeyboard+CollectionView.m
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMoreKeyboard+CollectionView.h"
#import "YDMoreKeyboardCell.h"

#define     SPACE_TOP        15
#define     WIDTH_CELL       60

@implementation YDMoreKeyboard (CollectionView)

- (void)registerCellClass{
    [self.collectionView registerClass:[YDMoreKeyboardCell class] forCellWithReuseIdentifier:@"YDMoreKeyboardCell"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.moreKeyboardData.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YDMoreKeyboardItem *item = [self.moreKeyboardData objectAtIndex:indexPath.row];
    YDMoreKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDMoreKeyboardCell" forIndexPath:indexPath];
    cell.item = item;
    YDWeakSelf(self);
    [cell setClickBlock:^(YDMoreKeyboardItem *cItem){
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(moreKeyboard:didSelectedItem:)]) {
            [weakself.delegate moreKeyboard:weakself didSelectedItem:cItem];
        }
    }];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//MARK: UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_CELL, (collectionView.height - 2*SPACE_TOP));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(SPACE_TOP, SPACE_TOP, SPACE_TOP, SPACE_TOP);
}


@end

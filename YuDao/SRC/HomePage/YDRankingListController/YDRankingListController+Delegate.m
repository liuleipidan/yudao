//
//  YDRankingListController+Delegate.m
//  YuDao
//
//  Created by 汪杰 on 16/12/13.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDRankingListController+Delegate.h"
#import "YDUserFilesController.h"

@implementation YDRankingListController (Delegate)

- (void)rl_registerCells{
    [self.collectionView registerClass:[YDRankingListCollectionCell class] forCellWithReuseIdentifier:@"YDRankingListCollectionCell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EmptyCell"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data ? self.data.count : 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.data.count) {
        YDRankingListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDRankingListCollectionCell" forIndexPath:indexPath];
        YDListModel *model = self.data[indexPath.row];
        [cell setDataType:self.dataType model:model ranking:indexPath.row];
        return cell;
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"EmptyCell" forIndexPath:indexPath];;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.data.count) {
        YDListModel *model = self.data[indexPath.row];
        //跳转到个人详情页面
        YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:model.ub_id];
        viewM.userName = model.ub_nickname;
        viewM.userHeaderUrl = model.ud_face;
        YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
        
        [self.parentViewController.navigationController pushViewController:userVC animated:YES];
    }
}

//整组缩进
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

@end

//
//  YDEmojiGroupDisplayView+CollectionView.m
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiGroupDisplayView+CollectionView.h"
#import "YDEmojiFaceCell.h"

@implementation YDEmojiGroupDisplayView (CollectionView)

- (void)egm_registerCells{
    [self.collectionView registerClass:[YDEmojiFaceCell class] forCellWithReuseIdentifier:@"YDEmojiFaceCell"];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
     
}

- (NSUInteger)transformModelByRowCount:(NSInteger)rowCount colCount:(NSInteger)colCount andIndex:(NSInteger)index{
    NSUInteger x = index / rowCount;
    NSUInteger y = index % rowCount;
    return colCount * y + x;
}

#pragma mark - # Delegate
//MARK: UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.displayData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    YDEmojiGroupDisplayModel *group = self.displayData[section];
    return group.pageItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDEmojiGroupDisplayModel *group = self.displayData[indexPath.section];
    NSInteger index = [self transformModelByRowCount:group.rowNumber colCount:group.colNumber andIndex:indexPath.row];
    YDEmoji *emoji = [group objectAtIndex:index];
    YDEmojiBaseCell *cell;
    if (group.type == YDEmojiTypeEmoji) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDEmojiFaceCell" forIndexPath:indexPath];
    }
    [cell setItem:emoji];
    
    return cell;
}

//MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDEmojiGroupDisplayModel *group = self.displayData[indexPath.section];
    NSInteger index = [self transformModelByRowCount:group.rowNumber colCount:group.colNumber andIndex:indexPath.row];
    YDEmoji *emoji = [group objectAtIndex:index];
    if (emoji) {
        if ([emoji.emojiID isEqualToString:@"-1"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(emojiGroupDisplayViewDeleteButtonPressed:)]) {
                [self.delegate emojiGroupDisplayViewDeleteButtonPressed:self];
            }
        }
        else if (self.delegate && [self.delegate respondsToSelector:@selector(emojiGroupDisplayView:didClickedEmoji:)]) {
            //FIXME: 表情类型
            emoji.type = group.type;
            [self.delegate emojiGroupDisplayView:self didClickedEmoji:emoji];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDEmojiGroupDisplayModel *group = self.displayData[indexPath.section];
    return group.cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    YDEmojiGroupDisplayModel *group = self.displayData[section];
    return group.sectionInsets;
}

//MARK: UIScrollViewDelegate
static float lastX = 0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x + 2.0) / scrollView.width;
    if (scrollView.contentOffset.x < lastX) {       // 右滑坐标修复
        page += (scrollView.contentOffset.x - scrollView.width * page > 3.0) ? 1 : 0;
    }
    lastX = scrollView.contentOffset.x;
    
    if (self.curPageIndex != page) {
        self.curPageIndex = page;
        if (page >= 0 && page < self.displayData.count && self.delegate && [self.delegate respondsToSelector:@selector(emojiGroupDisplayView:didScrollToPageIndex:forGroupIndex:)]) {
            YDEmojiGroupDisplayModel *group = self.displayData[page];
            [self.delegate emojiGroupDisplayView:self didScrollToPageIndex:group.pageIndex forGroupIndex:group.emojiGroupIndex];
        }
    }
}

@end

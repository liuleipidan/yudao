//
//  YDEmojiGroupDisplayView+CollectionView.h
//  YuDao
//
//  Created by 汪杰 on 2018/2/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDEmojiGroupDisplayView.h"

@interface YDEmojiGroupDisplayView (CollectionView)<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

- (void)egm_registerCells;

- (NSUInteger)transformModelByRowCount:(NSInteger)rowCount colCount:(NSInteger)colCount andIndex:(NSInteger)index;

@end

//
//  YDMoreKeyboard+CollectionView.h
//  YuDao
//
//  Created by 汪杰 on 2017/8/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMoreKeyboard.h"

@interface YDMoreKeyboard (CollectionView)<UICollectionViewDataSource,UICollectionViewDelegate>

- (void)registerCellClass;

@end

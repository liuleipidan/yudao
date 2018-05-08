//
//  YDRankingListController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 16/12/13.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDRankingListController.h"

@interface YDRankingListController (Delegate)<UICollectionViewDataSource,UICollectionViewDelegate>

- (void)rl_registerCells;

@end

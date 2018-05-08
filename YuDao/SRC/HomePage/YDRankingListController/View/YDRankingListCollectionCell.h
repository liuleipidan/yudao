//
//  YDRankingListCollectionCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDListModel.h"

@interface YDRankingListCollectionCell : UICollectionViewCell

- (void)setDataType:(YDRankingListDataType )dataType
              model:(YDListModel *)model
            ranking:(NSUInteger )ranking;

@end

//
//  YDRankingListController.h
//  YuDao
//
//  Created by 汪杰 on 16/12/13.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDListModel.h"
#import "YDRankingListCollectionCell.h"

@class YDRankingListController;
@protocol YDRankingListControllerDelegate <NSObject>

//排行榜数据加载完成
- (void)rankingListControllerDataDidLoad:(YDRankingListController *)controller;

@end

@interface YDRankingListController : YDViewController

@property (nonatomic, weak  ) id<YDRankingListControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<YDListModel *> *data;

@property (nonatomic, assign) YDRankingListDataType dataType;//数据类型

@property (nonatomic, strong) UICollectionView *collectionView;

//下载排行榜数据
- (void)downloadRankingListData;

@end

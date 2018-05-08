//
//  YDPhotoBrowerController.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDViewController.h"
#import "YDPhotoBrowserCell.h"

@interface YDPhotoBrowerController : YDViewController
{
    UICollectionView *_collectionView;
    UIPageControl   *_pageControl;
    NSMutableArray   *_data;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic,   copy) void (^needRefreshBlock) (NSMutableArray *data);

- (instancetype)initWithData:(NSArray *)data;

@end

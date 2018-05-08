//
//  YDBiBiCollectionView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YDBiBiCollectionViewType) {
    YDBiBiCollectionViewTypeNormal = 0,
    YDBiBiCollectionViewTypeUser,
};

@class YDBiBiCollectionView,YDPointAnnotation;
@protocol YDBiBiCollectionViewDelegate <NSObject>

- (void)collectionView:(YDBiBiCollectionView *)view scrollToItem:(YDPointAnnotation *)item;

@optional
- (void)collectionView:(YDBiBiCollectionView *)view selectedItem:(YDPointAnnotation *)item;

@end

@interface YDBiBiCollectionView : UICollectionView

@property (nonatomic,weak) id<YDBiBiCollectionViewDelegate> bibiDelegate;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                   dataSource:(NSArray *)dataSource
                     cellType:(YDBiBiCollectionViewType)type;

- (instancetype)initWithDataSource:(NSArray *)dataSource
                          cellType:(YDBiBiCollectionViewType)type;


/**
 刷新数据

 @param data 数据源
 @param type cell类型
 */
- (void)reloadData:(NSArray *)data cellType:(YDBiBiCollectionViewType )type;

@end

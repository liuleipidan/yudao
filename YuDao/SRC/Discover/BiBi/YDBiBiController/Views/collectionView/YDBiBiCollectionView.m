//
//  YDBiBiCollectionView.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDBiBiCollectionView.h"
#import "YDBiBiNormalCollectionViewCell.h"
#import "YDCollectionCenterXItemFlowLayout.h"

static NSString *kBiBiCollectionViewCellId;

@interface YDBiBiCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) YDBiBiCollectionViewType cellType;

@property (nonatomic, strong) NSArray *data;

@end

@implementation YDBiBiCollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                   dataSource:(NSArray *)dataSource
                     cellType:(YDBiBiCollectionViewType)type{
    NSLog(@"layout = %@",layout);
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _data = dataSource;
        _cellType = type;
        
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        CGFloat itemH;
        if (type == YDBiBiCollectionViewTypeNormal) {
            itemH = 92.0;
            kBiBiCollectionViewCellId = @"YDBiBiNormalCollectionViewCell";
            [self registerClass:[YDBiBiNormalCollectionViewCell class] forCellWithReuseIdentifier:kBiBiCollectionViewCellId];
        }else{
            itemH = 0;
        }
    }
    return self;
}

- (instancetype)initWithDataSource:(NSArray *)dataSource
                          cellType:(YDBiBiCollectionViewType)type{
    if (self = [super init]) {
        _data = dataSource;
        _cellType = type;
        
        self.dataSource = self;
        self.delegate = self;
        
        CGFloat itemH;
        if (type == YDBiBiCollectionViewTypeNormal) {
            itemH = 92.0;
            kBiBiCollectionViewCellId = @"YDBiBiNormalCollectionViewCell";
            [self registerClass:[YDBiBiNormalCollectionViewCell class] forCellWithReuseIdentifier:kBiBiCollectionViewCellId];
        }else{
            itemH = 0;
        }
        
        
        YDCollectionCenterXItemFlowLayout *layout = [YDCollectionCenterXItemFlowLayout new];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH-30, itemH);
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.headerReferenceSize = CGSizeMake(15, itemH);
        layout.footerReferenceSize = CGSizeMake(15, itemH);
        
        self.collectionViewLayout = layout;
    }
    return self;
}

- (void)reloadData:(NSArray *)data cellType:(YDBiBiCollectionViewType )type{
    _data = data;
    _cellType = type;
    [self reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //CGPoint offset = scrollView.contentOffset;
    //NSLog(@"offset.x = %f",offset.x);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _data.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_cellType == YDBiBiCollectionViewTypeNormal) {
        YDBiBiNormalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBiBiCollectionViewCellId forIndexPath:indexPath];
        cell.model = _data[indexPath.row];
        return cell;
        
    }
    return [UICollectionViewCell new];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bibiDelegate && [self.bibiDelegate respondsToSelector:@selector(collectionView:scrollToItem:)]) {
        [self.bibiDelegate collectionView:self selectedItem:_data[indexPath.row]];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //NSLog(@"offsetX = %f",scrollView.contentOffset.x);
    //NSLog(@"velocity: x = %f, y = %f",velocity.x,velocity.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating:offsetX = %f",scrollView.contentOffset.x);
    __block NSIndexPath *centerIndex = nil;
    [self.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"indexPath.row = %ld",obj.row);
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:obj];
        CGRect cellFrame =  [self convertRect:cell.frame toView:self.superview];
        CGFloat cellCenterX = self.superview.centerX;
        if (cellCenterX > cellFrame.origin.x && cellCenterX < (cellFrame.origin.x+cellFrame.size.width)) {
            centerIndex = obj;
        }
    }];
    if (centerIndex) {
        if (self.bibiDelegate && [self.bibiDelegate respondsToSelector:@selector(collectionView:scrollToItem:)]) {
            [self.bibiDelegate collectionView:self scrollToItem:_data[centerIndex.row]];
        }
    }
//    [self.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"obj.x = %f",obj.x);
//        CGRect cellFrame =  [self convertRect:obj.frame toView:self.superview];
//        
//        CGFloat cellCenterX = (cellFrame.origin.x+cellFrame.size.width)*0.5;
//        NSLog(@"cellCenterX = %f,self.view.centerX = %f",cellCenterX,self.superview.centerX);
//    }];
    
}

@end

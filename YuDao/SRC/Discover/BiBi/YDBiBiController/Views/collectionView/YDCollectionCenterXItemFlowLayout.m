//
//  YDCollectionCenterXItemFlowLayout.m
//  YuDao
//
//  Created by 汪杰 on 2017/7/6.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDCollectionCenterXItemFlowLayout.h"

@implementation YDCollectionCenterXItemFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
#pragma mark - 重写父类的方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGRect contentFrame;
    contentFrame.size = self.collectionView.frame.size;
    contentFrame.origin = proposedContentOffset;
    
    //2. 计算在可视范围的距离中心线最近的Item
    NSArray *array = [self layoutAttributesForElementsInRect:contentFrame];
    CGFloat minCenterX = CGFLOAT_MAX;
    CGFloat collectionViewCenterX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - collectionViewCenterX) < ABS(minCenterX)){
            minCenterX = attrs.center.x - collectionViewCenterX;
        }
    }
    
    //3. 补回ContentOffset，则正好将Item居中显示
    return CGPointMake(proposedContentOffset.x + minCenterX, proposedContentOffset.y);
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0){
    //NSLog(@"2proposedContentOffset.x = %f",proposedContentOffset.x);
    return proposedContentOffset;
}

@end

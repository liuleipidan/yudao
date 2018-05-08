//
//  YDPopularCarBrandView.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/16.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDPCBCollectionViewCell.h"

@class YDPopularCarBrandView;
@protocol YDPopularCarBrandViewDelegate <NSObject>

- (void)popularCarBrandView:(YDPopularCarBrandView *)view didSelectedItem:(YDCarBrand *)item;

@end

@interface YDPopularCarBrandView : UIView

@property (nonatomic, weak  ) id<YDPopularCarBrandViewDelegate> delegate;

@property (nonatomic, strong) NSArray<YDCarBrand *> *data;

@end

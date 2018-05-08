//
//  YDSingleRLBottomView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDRankingListModel.h"
#import "YDSingleRLLikeButton.h"

@interface YDSingleRLBottomView : UIView

@property (nonatomic, strong) YDRankingListModel *item;

- (void)showWithAnimation:(BOOL)animated;

- (void)dismissWithAnimation:(BOOL)animated;

@end

//
//  YDTestCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDTestsModel.h"
#import "YDSlider.h"

@class YDTestAQICell;
@protocol YDTestCellDelegate <NSObject>

@optional
- (void)testAQICellDidClickedBuyVe_AIR:(YDTestAQICell *)cell;

@end

@interface YDTestCell : UITableViewCell

@property (nonatomic, weak  ) id<YDTestCellDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) YDTestsModel *model;

@end

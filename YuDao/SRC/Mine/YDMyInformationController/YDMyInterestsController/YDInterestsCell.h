//
//  YDInterestsCell.h
//  YuDao
//
//  Created by 汪杰 on 17/1/11.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDInterestModel.h"

@class YDInterestsCell;
@protocol YDInterestsCellDelegate <NSObject>

- (void)interestsCell:(YDInterestsCell *)cell selectedBtn:(UIButton *)btn selectedItem:(YDInterest *)item;

@end

@interface YDInterestsCell : UITableViewCell

@property (nonatomic,weak) id<YDInterestsCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *labelImageV;  //标签视图

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIView     *containerView;//兴趣容器

@property (nonatomic, strong) YDInterestModel *model;

@end

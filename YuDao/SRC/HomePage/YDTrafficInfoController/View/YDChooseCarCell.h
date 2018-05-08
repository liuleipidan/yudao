//
//  YDChooseCarCell.h
//  YuDao
//
//  Created by 汪杰 on 16/12/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDCarDetailModel.h"

@interface YDChooseCarCell : UITableViewCell

@property (nonatomic, strong) UIButton *carIcon;
@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) YDCarDetailModel *model;

@end

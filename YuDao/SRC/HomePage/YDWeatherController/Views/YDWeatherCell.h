//
//  YDWeatherCell.h
//  YuDao
//
//  Created by 汪杰 on 16/12/15.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDWeatherCell : UITableViewCell

@property (nonatomic, strong) UIView     *backView;

@property (nonatomic, strong) UIImageView *iconV;

@property (nonatomic, strong) UIView     *lineView;

@property (nonatomic, strong) UILabel    *titleLabel;

@property (nonatomic, strong) UILabel    *subTitleLabel;

@end

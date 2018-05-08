//
//  YDUserBaseInterestCell.h
//  YuDao
//
//  Created by 汪杰 on 16/12/30.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDUserBaseInterestCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) NSArray *f_tags;//兴趣父id数组

@property (nonatomic, strong) NSArray *interestArray;//兴趣数组

@end

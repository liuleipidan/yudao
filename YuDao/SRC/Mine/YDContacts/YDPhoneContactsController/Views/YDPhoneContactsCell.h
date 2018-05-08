//
//  YDPhoneContactsCell.h
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDContactsModel.h"

@class YDPhoneContactsCell;
@protocol YDPhoneContactsCellDelegate <NSObject>

- (void)phoneContactsCell:(YDPhoneContactsCell *)cell touchedButton:(UIButton *)btn model:(YDContactsModel *)model;

@end

@interface YDPhoneContactsCell : UITableViewCell

@property (nonatomic, weak ) id<YDPhoneContactsCellDelegate> delegate;


@property (nonatomic, strong) YDContactsModel *model;

@end

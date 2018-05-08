//
//  YDAuthenticateCell.h
//  YuDao
//
//  Created by 汪杰 on 17/1/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDAuthenticateModel.h"

@class YDAuthenticateCell;
@protocol YDAuthenticateCellDelegate <NSObject>

- (void)authenticateCell:(YDAuthenticateCell *)cell clickedPopViewButton:(UIButton *)sender;

@end

@interface YDAuthenticateCell : UITableViewCell

@property (nonatomic, weak  ) id<YDAuthenticateCellDelegate> delegate;

@property (nonatomic, strong) YDAuthenticateModel *model;

@end

//
//  YDHPDynamicCell.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/19.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDynamicModel.h"

@class YDHPDynamicCell;
@protocol YDHPDynamicCellDelegate <NSObject>

- (void)HPDynamicCell:(YDHPDynamicCell *)cell didClickedUserAvatar:(YDDynamicModel *)model;

- (void)HPDynamicCell:(YDHPDynamicCell *)cell didClickedPlayButton:(YDDynamicModel *)model;

@end

@interface YDHPDynamicCell : UITableViewCell

@property (nonatomic, weak  ) id<YDHPDynamicCellDelegate> delegate;

@property (nonatomic, strong) YDDynamicModel *model;


@end

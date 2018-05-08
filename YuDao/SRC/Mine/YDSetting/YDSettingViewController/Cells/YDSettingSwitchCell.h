//
//  YDSettingSwitchCell.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDSettingItem.h"

@class YDSettingSwitchCell;
@protocol YDSettingSwitchCellDelegate <NSObject>

- (void)settingSwitchCell:(YDSettingSwitchCell *)cell item:(YDSettingItem *)item switchBtn:(UISwitch *)switchBtn;

@end

@interface YDSettingSwitchCell : UITableViewCell

@property (nonatomic,weak) id<YDSettingSwitchCellDelegate> delegate;

@property (nonatomic, strong) YDSettingItem *item;

/**
 是否开启代理，默认YES
 */
@property (nonatomic,assign) BOOL openDelegate;;

@end

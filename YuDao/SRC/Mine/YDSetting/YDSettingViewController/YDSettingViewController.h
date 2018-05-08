//
//  YDSettingViewController.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/7.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDSettingCell.h"
#import "YDSettingSwitchCell.h"
#import "YDSettingGroup.h"

#define     HEIGHT_SETTING_CELL             44.0f
#define     HEIGHT_SETTING_TOP_SPACE        15.0f
#define     HEIGHT_SETTING_BOTTOM_SPACE     12.0f

@interface YDSettingViewController : UITableViewController<YDSettingSwitchCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@end

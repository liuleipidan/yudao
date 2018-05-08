//
//  YDPopDownCell.h
//  YuDao
//
//  Created by 汪杰 on 16/12/1.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDAddMenuItem.h"

@interface YDPopDownCell : UITableViewCell

@property (nonatomic, strong) YDAddMenuItem *item;

@property (nonatomic, assign) BOOL hideSeperatorLine;

@end

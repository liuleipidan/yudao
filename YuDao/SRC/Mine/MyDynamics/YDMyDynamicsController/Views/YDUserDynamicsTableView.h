//
//  YDUserDynamicsTableView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/15.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDStretchableView.h"
#import "YDMomentCell.h"

@protocol YDUserDynamicsTableViewDelegate <YDMomentCellDelegate>



@end

@interface YDUserDynamicsTableView : UITableView

@property (nonatomic, weak  ) id<YDUserDynamicsTableViewDelegate> yd_delegate;

/**
 头部图片链接
 */
@property (nonatomic, copy  ) NSString *headerImageStr;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *data;


@end

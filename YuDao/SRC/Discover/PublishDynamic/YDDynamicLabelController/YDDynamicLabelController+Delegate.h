//
//  YDDynamicLabelController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/3.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDDynamicLabelController.h"
#import "YDDynamicHotLabelCell.h"

@interface YDDynamicLabelController (Delegate)<UITableViewDataSource,UITableViewDelegate,YDDynamicHotLabelCellDelegate>

- (void)registerCells;

@end

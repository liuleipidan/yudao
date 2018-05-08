//
//  YDTestsController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/21.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import "YDTestsController.h"

@interface YDTestsController (Delegate)<UITableViewDataSource,UITableViewDelegate,YDTestCellDelegate>


- (void)registerCells;

@end

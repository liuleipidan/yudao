//
//  YDLikePersonController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 16/11/23.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDLikePersonController.h"

@interface YDLikePersonController (Delegate)<UITableViewDataSource,UITableViewDelegate>

- (void)registerCellClass;

@end

//
//  YDUserFilesController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 16/12/29.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDUserFilesController.h"
#import "YDDynamicDetailsController.h"

@interface YDUserFilesController (Delegate)<UITableViewDataSource,UITableViewDelegate,YDDynamicsTableViewDelegate,YDUserFilesBottomViewDelegate,YDUFHeaderViewDelegate,YDDynamicDetailsControllerDelegate>

- (void)registerCellClass;

@end

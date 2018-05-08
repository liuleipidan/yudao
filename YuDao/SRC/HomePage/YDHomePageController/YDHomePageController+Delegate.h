//
//  YDHomePageController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/31.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDHomePageController.h"

@interface YDHomePageController (Delegate)<UITableViewDataSource,UITableViewDelegate,YDHomePageManagerDelegate,YDRankingListControllerDelegate,YDHPDynamicControllerDelegate>

- (void)registerCells;

@end

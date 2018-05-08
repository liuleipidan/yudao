//
//  YDMomentViewController+TableView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDMomentViewController.h"
#import "YDMomentImagesCell.h"
#import "YDMomentVideoCell.h"
#import "YDDynamicDetailsController.h"

@interface YDMomentViewController (TableView)<UITableViewDataSource,UITableViewDelegate,YDMomentCellDelegate,YDDynamicDetailsControllerDelegate>

- (void)registerCellToTableView:(UITableView *)tableView;

@end

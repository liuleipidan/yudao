//
//  YDContactsViewController+Delegate.h
//  YuDao
//
//  Created by 汪杰 on 16/11/2.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDContactsViewController.h"

@interface YDContactsViewController (Delegate)<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,YDFriendCellDelegate,YDPushMessageManagerDelegate>

- (void)registerCellClass;

@end

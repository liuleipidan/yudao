//
//  YDSearchResultTableViewController.m
//  YuDao
//
//  Created by 汪杰 on 2017/4/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDSearchResultTableViewController.h"

@interface YDSearchResultTableViewController ()

@end

@implementation YDSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableFooterView:[UIView new]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //下移避免遮挡
    self.tableView.y = STATUSBAR_HEIGHT + SEARCHBAR_HEIGHT;
    self.tableView.height = SCREEN_HEIGHT-self.tableView.y;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


#pragma mark - UIScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //关闭键盘
    [YDNotificationCenter postNotificationName:kSearchResultTableViewDidScrollNotification object:nil];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

@end

//
//  YDSearchResultsTableViewController.m
//  YuDao
//
//  Created by 汪杰 on 16/10/14.
//  Copyright © 2016年 汪杰. All rights reserved.
//

#import "YDSearchResultsTableViewController.h"
#import "YDUserFilesController.h"

@interface YDSearchResultsTableViewController ()


@end

@implementation YDSearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorGrayBG];
    self.data = [NSMutableArray array];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.tableView.rowHeight = 70.0f;
    
    [self.tableView yd_setContentInsetAdjustmentBehavior:2];
    
    [self.tableView registerClass:[YDSearchCell class] forCellReuseIdentifier:@"YDSearchCell"];
    
}

- (void)setData:(NSArray *)data{
    _data = data;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"用户";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data? self.data.count: 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDSearchCell"];
    YDSearchModel *searchModel = self.data[indexPath.row];
    cell.searchModel = searchModel;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDSearchModel *searchModel = self.data[indexPath.row];
    YDUserFilesViewModel *viewM = [[YDUserFilesViewModel alloc] initWithUserId:searchModel.ub_id];
    viewM.userName = searchModel.ub_nickname;
    viewM.userHeaderUrl = searchModel.ud_face;
    YDUserFilesController *userVC = [[YDUserFilesController alloc] initWithViewModel:viewM];
    YDLog(@"pred = %@ pring = %@",self.presentedViewController,self.presentingViewController);
    [self.presentingViewController.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    YDWeakSelf(self);
    NSString *searchString = searchController.searchBar.text;
    if (searchString.length == 0) {
        return;
    }
    [YDNetworking GET:kSearchUserURL parameters:@{@"nickname":searchString} success:^(NSNumber *code, NSString *status, id data) {
        NSArray *tempArray = [YDSearchModel mj_objectArrayWithKeyValuesArray:data];
        [weakself setData:tempArray];
    } failure:^(NSError *error) {
        
    }];
}

@end

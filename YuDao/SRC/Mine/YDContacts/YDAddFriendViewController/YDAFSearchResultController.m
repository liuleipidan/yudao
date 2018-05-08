//
//  YDAFSearchResultController.m
//  YuDao
//
//  Created by 汪杰 on 2017/4/27.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import "YDAFSearchResultController.h"
#import "YDSearchCell.h"
#import "YDUserFilesController.h"

@interface YDAFSearchResultController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation YDAFSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorGrayBG];
    self.data = [NSMutableArray array];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.tableView registerClass:[YDSearchCell class] forCellReuseIdentifier:@"YDSearchCell"];
    
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
    NSString *searchText = [searchController.searchBar.text lowercaseString];
    YDWeakSelf(self);
    [YDNetworking GET:kSearchUserURL parameters:@{@"nickname":searchText} success:^(NSNumber *code, NSString *status, id data) {
        NSArray *tempArray = [YDSearchModel mj_objectArrayWithKeyValuesArray:data];
        weakself.data = [NSArray arrayWithArray:tempArray];
        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


@end
